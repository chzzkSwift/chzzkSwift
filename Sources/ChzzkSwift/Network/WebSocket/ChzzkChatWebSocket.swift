import Foundation
import Starscream

@available(macOS 10.15, *)
public final class ChzzkChatWebSocket: WebSocketDelegate {
    private var isConnected: Bool = false
    private let chatChannelId: String
    private var socket: WebSocket?
    private var accessToken: String?
    private var uid: String?
    private var sid: String?
    private var pingTimeoutId: DispatchSourceTimer?

    private func getServerId(from chatChannelId: String) -> Int {
        let sum = chatChannelId.unicodeScalars.map { Int($0.value) }.reduce(0, +)
        let serverId = abs(sum) % 9 + 1
        return serverId
    }

    public init(chatChannelId: String) {
        self.chatChannelId = chatChannelId
    }

    public func chatAccessToken() async throws -> String {
        return try await ChzzkSwift().getChatAccessToken(chatChannelId)
    }

    public func connect() async {
        if isConnected {
            print("Already connected")
            return
        }

        let url = URL(string: "wss://kr-ss\(getServerId(from: chatChannelId)).chat.naver.com/chat")!
        print(url)
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        await sendInitialMessages()

    }

    public func disconnect() {
        guard let socket = socket else { return }
        socket.disconnect()
        isConnected = false
        stopPingTimer()
    }

    private func sendInitialMessages() async {
        do {
            let accessToken = try await chatAccessToken()
            let initialMessage = ChzzkPingMessage()
            sendSynchronousMessage(message: initialMessage.getData())
            let connectMessage = ChzzkInitialConnectMessage(chatChannelId: chatChannelId, accessToken: accessToken, uid: uid)
            sendSynchronousMessage(message: connectMessage.getData())

        } catch {
            print("Error fetching access token: \(error)")
        }
    }

    private func sendSynchronousMessage(message: Data) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        socket?.write(data: message, completion: {
            dispatchGroup.leave()
        })

        dispatchGroup.wait()
    }

    private func requestRecentChat() {
        guard let sid = sid else { return }
        let recentChatMessage = ChzzkRecentChatMessage(chatChannelId: chatChannelId, sid: sid).getData()
        socket?.write(data: recentChatMessage)
    }

    public func didReceive(event: WebSocketEvent, client _: WebSocketClient) {
        switch event {
        case let .connected(headers):
            isConnected = true
            print("WebSocket connected with headers: \(headers)")
            Task {
                await sendInitialMessages()
            }
            startPingTimer() // 연결이 성공하면 핑 타이머 시작
        case let .disconnected(reason, code):
            isConnected = false
            print("WebSocket disconnected: \(reason) with code: \(code)")
            reconnect()
        case let .text(string):
            handleMessage(string: string)
        case let .binary(data):
            print("Received data: \(data.count)")
            handleMessage(data: data)
        case .ping:
            print("Ping received")
        case .pong:
            print("Pong received")
        case let .viabilityChanged(viable):
            print("Viability changed: \(viable)")
            if !viable {
                reconnect()
            }
        case .reconnectSuggested:
            print("Reconnect suggested")
            reconnect()
        case .cancelled:
            isConnected = false
            print("WebSocket cancelled")
        case let .error(error):
            isConnected = false
            if let error = error {
                print("WebSocket error: \(error.localizedDescription)")
            } else {
                print("WebSocket encountered an error")
            }
        case .peerClosed:
            print("WebSocket peer closed")
        }
    }

    private func handleMessage(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            handleJSONMessage(json)
        } catch {
            print("Error parsing message: \(error.localizedDescription)")
        }
    }

    private func handleMessage(string: String) {
        do {
            let data = string.data(using: .utf8)!
            try handleMessage(data: data)
        } catch {
            print("Error parsing string message: \(error)")
        }
    }

    private func handleJSONMessage(_ json: [String: Any]) {
        guard let cmdValue = json["cmd"] as? Int, let cmd = ChzzkChatCmd(rawValue: cmdValue) else { return }
        switch cmd {
        case .pong: // PONG
            print("Received PONG")
        case .ping:
            print("Recieved PING")
            sendPong()
        case .connected: // CONNECTED
            if let body = json["bdy"] as? [String: Any], let sid = body["sid"] as? String {
                self.sid = sid
                requestRecentChat()
            }
        case .recentChat: // RECENT_CHAT
            print("Received recent chat messages")
            if let body = json["bdy"] as? [String: Any] {
                handleRecentChatMessages(body)
            }
        case .chat: // CHAT
            print("Received chat message")
            if let body = json["bdy"] as? [[String: Any]] {
                handleChatMessages(body)
            }
        case .donation:
            print("Received donation message")
            if let body = json["bdy"] as? [String: Any] {
                handleDonationMessage(body)
            }
        default:
            print("Unknown command received: \(cmd)")
        }
    }

    private func handleChatMessages(_ messages: [[String: Any]]) {
        for messageData in messages {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: messageData)
                let chatMessage = try JSONDecoder().decode(ChzzkChatMessage.self, from: jsonData)
                let chzzkMessage = ChzzkMessage(fromChat: chatMessage)
                print("Chat message: \(chzzkMessage)")
            } catch {
                print("Error parsing chat message: \(error)")
            }
        }
    }

    private func handleDonationMessage(_ messageData: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageData)
            let donationMessage = try JSONDecoder().decode(ChzzkDonationMessage.self, from: jsonData)
            let chzzkMessage = ChzzkMessage(fromDonation: donationMessage)
            print("Donation message: \(chzzkMessage)")
        } catch {
            print("Error parsing donation message: \(error)")
        }
    }
    
    private func handleRecentChatMessages(_ messageData: [String: Any]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: messageData)
                let recentChatMessage = try JSONDecoder().decode(ChzzkNewRecentChatMessage.self, from: jsonData)
                for message in recentChatMessage.messageList {
                    let chzzkMessage = ChzzkMessage(fromRecentChat: message)
                    print("Recent chat message: \(chzzkMessage)")
                }
            } catch {
                print("Error parsing recent chat messages: \(error)")
            }
        }

    private func startPingTimer() {
        stopPingTimer()
        pingTimeoutId = DispatchSource.makeTimerSource()
        pingTimeoutId?.schedule(deadline: .now() + 10, repeating: 15.0)
        pingTimeoutId?.setEventHandler { [weak self] in
            self?.sendPing()
        }
        pingTimeoutId?.resume()
    }

    private func stopPingTimer() {
        pingTimeoutId?.cancel()
        pingTimeoutId = nil
    }

    private func sendPing() {
        print("Send PING")
        guard let socket = socket else { return }
        let pingMessage = ChzzkPingMessage()

        let pingData = pingMessage.getData()
        socket.write(ping: pingData)
    }

    private func sendPong() {
        print("Send PONG")
        guard let socket = socket else { return }
        let pongMessage = ChzzkPongMessage()

        let pongData = pongMessage.getData()
        socket.write(pong: pongData)
    }

    public func reconnect() {
        disconnect()
        Task {
            await connect()
        }
    }
}

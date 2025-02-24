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
        requestRecentChat()
    }

    public func disconnect() {
        guard let socket = socket else { return }
        socket.disconnect()
        isConnected = false
    }

    private func sendInitialMessages() async {
        do {
            let accessToken = try await chatAccessToken()
            
//            let initialMessage = "{\"ver\":\"3\",\"cmd\":0}"
//            sendSynchronousMessage(message: initialMessage)
            
            let connectMessage = """
            {"ver":"3","cmd":100,"svcid":"game","cid":"\(chatChannelId)","bdy":{"uid":"\(uid ?? "null")","devType":2001,"accTkn":"\(accessToken)","auth":"READ","libVer":"4.9.3","osVer":"macOS/10.15.7","devName":"Google Chrome/126.0.0.0","locale":"ko","timezone":"Asia/Seoul"},"tid":1}
            """
            sendSynchronousMessage(message: connectMessage)
            
        } catch {
            print("Error fetching access token: \(error)")
        }
    }

    private func sendSynchronousMessage(message: String) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        socket?.write(string: message, completion: {
            dispatchGroup.leave()
        })
        
        dispatchGroup.wait()
    }
    private func requestRecentChat() {
        guard let sid = sid else { return }

        let recentChatMessage = """
        {"ver":"3","cmd":5101,"svcid":"game","cid":"\(chatChannelId)","sid":"\(sid)","bdy":{"recentMessageCount":50},"tid":2}
        """
        socket?.write(string: recentChatMessage)
    }

    public func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("WebSocket connected with headers: \(headers)")
            Task {
                await sendInitialMessages()
            }
        case .disconnected(let reason, let code):
            isConnected = false
            print("WebSocket disconnected: \(reason) with code: \(code)")
            reconnect()
        case .text(let string):
//            print("Received text: \(string)")
            handleMessage(string: string)
        case .binary(let data):
            print("Received data: \(data.count)")
            handleMessage(data: data)
        case .ping(_):
            print("Ping received")
        case .pong(_):
            print("Pong received")
        case .viabilityChanged(let viable):
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
        case .error(let error):
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
        guard let cmd = json["cmd"] as? Int else { return }

        switch cmd {
        case 10000: // PONG
            print("Received PONG")
        case 10100: // CONNECTED
            if let body = json["bdy"] as? [String: Any], let sid = body["sid"] as? String {
                self.sid = sid
                requestRecentChat()
            }
        case 15101: // RECENT_CHAT
            print("Received recent chat messages")
            if let body = json["bdy"] as? [String: Any], let messages = body["messageList"] as? [[String: Any]] {
                handleChatMessages(messages)
            }
        case 93101: // CHAT
            print("Received chat message")
            if let body = json["bdy"] as? [[String: Any]] {
                handleChatMessages(body)
            }
        default:
            print("Unknown command received: \(cmd)")
        }
    }

    private func handleChatMessages(_ messages: [[String: Any]]) {
        for message in messages {
            if let content = message["msg"] as? String {
                print("Chat message: \(content)")
            }
        }
    }

    private func startPingTimer() {
        stopPingTimer()
        pingTimeoutId = DispatchSource.makeTimerSource()
        pingTimeoutId?.schedule(deadline: .now() + 20.0, repeating: 20.0)
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
        guard let socket = socket else { return }
        let pingMessage = "{\"ver\":\"3\",\"cmd\":0}"
        socket.write(string: pingMessage)
    }

    public func reconnect() {
        disconnect()
        Task {
            await connect()
        }
    }
}

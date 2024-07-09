import Foundation
import Starscream

@available(macOS 10.15, *)
public final class ChzzkChatWebSocket: WebSocketDelegate {


    private var isConnected: Bool = false
    private let chatChannelId: String
    private var socket: WebSocket?

    private func getServerId(from chatChannelId: String) -> Int {
        let sum = chatChannelId.unicodeScalars.map { Int($0.value) }.reduce(0, +)
        let serverId = abs(sum) % 9 + 1
        return serverId
    }

    public init(chatChannelId: String) {
        self.chatChannelId = chatChannelId
    }

    public func chatAccessToken() async throws -> String {
        return try! await ChzzkSwift().getChatAccessToken(chatChannelId)
    }

    public func connect() async {
        let url = URL(string: "wss://kr-ss\(getServerId(from: chatChannelId)).chat.naver.com/chat")!
        print(url)
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        isConnected = true
        print("connected")
        let a = try! await chatAccessToken()
        let b = try! JSONEncoder().encode(ChatBody(chatAccessToken: a, chatChannelId: chatChannelId, uid: nil))
        print(String(data: b, encoding: .utf8)!)
        socket?.write(data: b)
    }

    public func disconnect() {
        guard let socket: WebSocket = socket else { return }
        socket.disconnect()
        isConnected = false
    }

    public func didReceive(event: Starscream.WebSocketEvent, client : any Starscream.WebSocketClient) {
        switch event {
        case let .connected(headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case let .disconnected(reason, code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case let .text(string):
            print("Received text: \(string)")
        case let .binary(data):
            print("Received data: \(data.count)")
        case .ping:
            break
        case .pong:
            break
        case .viabilityChanged:
            break
        case .reconnectSuggested:
            break
        case .cancelled:
            isConnected = false
        case let .error(error):
            isConnected = false
            print(error)
            
        case .peerClosed:
            break
        }
    }
}

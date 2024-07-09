import Foundation
import Starscream

public final class ChzzkChatWebSocket: WebSocketDelegate {
    private var connected: Bool = false
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

    public func connect() {
        let url = URL(string: "wss://kr-ss\(self.getServerId(from: self.chatChannelId)).chat.naver.com/chat")!
        print(url)
        var request = URLRequest(url: url)
        request.timeoutInterval = 5



        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()

    }

    public func disconnect() {
        guard let socket: WebSocket = socket else { return }
    }

    public func didReceive(event _: Starscream.WebSocketEvent, client _: any Starscream.WebSocketClient) {}


}

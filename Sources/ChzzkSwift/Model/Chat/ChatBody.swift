
// struct ChatBody: Codable {
//     let chatAccessToken: String
//     let chatChannelId: String
//     let uid: String?
// }
import Foundation

public protocol ChzzkMessageBodyProtocol: Codable, CustomStringConvertible {
    func getData() -> Data

    var ver: String { get }
    var cmd: ChzzkChatCmd { get }
}

// MARK: - Chzzk Chat Messages

public struct ChzzkInitialConnectMessage: ChzzkMessageBodyProtocol {
    public init(chatChannelId: String, accessToken: String, uid: String?) {
        svcid = "game"
        cid = chatChannelId
        bdy = ChzzkInitialBdy(accTkn: accessToken, auth: nil, uid: uid)
        tid = 1
    }

    public var ver: String = "3"
    public var cmd: ChzzkChatCmd = .connect
    let tid: Int
    let svcid: String
    let cid: String
    let bdy: ChzzkInitialBdy

    public var description: String {
        return String(data: getData(), encoding: .utf8)!
    }

    public func getData() -> Data {
        return _encode(self)
    }
}

public struct ChzzkRecentChatMessage: ChzzkMessageBodyProtocol {
    public init(chatChannelId: String, sid: String) {
        self.sid = sid
        cid = chatChannelId
        svcid = "game"
        bdy = ["recentMessageCount": 50]
        tid = 2
    }

    public var ver: String = "3"
    public var cmd: ChzzkChatCmd = .requestRecentChat
    let tid: Int
    let cid: String
    let sid: String
    let svcid: String
    let bdy: [String: Int]

    public var description: String {
        return String(data: getData(), encoding: .utf8)!
    }

    public func getData() -> Data {
        return _encode(self)
    }
}

public struct ChzzkPongMessage: ChzzkMessageBodyProtocol {
    public init(_ ver: String = "3") {
        self.ver = ver
    }

    public func getData() -> Data {
        return _encode(self)
    }

    public var cmd: ChzzkChatCmd = .pong
    public var ver: String
    public var description: String {
        return String(data: getData(), encoding: .utf8)!
    }
}

public struct ChzzkPingMessage: ChzzkMessageBodyProtocol {
    init(_ ver: String = "3") {
        self.ver = ver
        cmd = .ping
    }

    public func getData() -> Data {
        return _encode(self)
    }

    public var ver: String
    public var cmd: ChzzkChatCmd
    public var description: String {
        return String(data: getData(), encoding: .utf8)!
    }
}

// MARK: - Chat Bdy

public struct ChzzkInitialBdy: Codable {
    let accTkn: String
    let devType: Int
    let auth: String
    let uid: String?
    let libVer: String
    let osVer: String
    let locale: String
    let timezone: String
    init(accTkn: String, auth: String?, uid: String?) {
        self.accTkn = accTkn
        devType = 2001
        self.auth = auth == nil ? "READ" : "WRITE"
        self.uid = uid ?? "null"
        libVer = "4.9.3"
        osVer = "macOS/10.15.7"
        locale = "ko"
        timezone = "Asia/Seoul"
    }
}

// MARK: - Chat Enums

public enum ChzzkChatCmd: Int, Codable {
    case ping = 0
    case pong = 10000
    case connect = 100
    case connected = 10100
    case requestRecentChat = 5101
    case recentChat = 15101
    case event = 93006
    case chat = 93101
    case donation = 93102
    case kick = 94005
    case block = 94006
    case blind = 94008
    case notice = 94010
    case penalty = 94015
    case sendChat = 3101
}

public enum ChzzkChatType: Int {
    case text = 1
    case image = 2
    case sticker = 3
    case video = 4
    case rich = 5
    case donation = 10
    case subscription = 11
    case systemMessage = 30
}

// MARK: - Chat Simple Utils

private func _encode<T: Encodable>(_ value: T) -> Data {
    let encoder = JSONEncoder()
    #if DEBUG
        encoder.outputFormatting = .prettyPrinted
    #endif
    return try! encoder.encode(value)
}

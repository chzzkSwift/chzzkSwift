
// struct ChatBody: Codable {
//     let chatAccessToken: String
//     let chatChannelId: String
//     let uid: String?
// }
import Foundation

public protocol ChzzkMessageBodyProtocol: Codable, CustomStringConvertible {
    func getData() -> Data

    var ver: String { get }
    var tid: Int { get }
}

public struct ChzzkInitialConnectMessage: ChzzkMessageBodyProtocol {
    public init(chatChannelId: String, accessToken: String, uid: String?) {
        svcid = "game"
        cid = chatChannelId
        bdy = ChzzkBdy(accTkn: accessToken, auth: nil, uid: uid)
        cmd = ChzzkChatCmd.connect
    }

    public var ver: String = "3"
    public var tid: Int = 1
    let svcid: String
    let cid: String
    let bdy: ChzzkBdy
    let cmd: ChzzkChatCmd

    public var description: String {
        let encoder = JSONEncoder()
        #if DEBUG
            encoder.outputFormatting = .prettyPrinted
        #endif
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }

    public func getData() -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(self)
    }
}

public struct ChzzkRecentChatMessage: ChzzkMessageBodyProtocol {
    public init(chatChannelId: String, sid: String) {
        self.sid = sid
        cid = chatChannelId
        svcid = "game"
        cmd = .requestRecentChat
        bdy = ["recentMessageCount": 50]
    }

    public var ver: String = "3"
    public var tid: Int = 2
    let cid: String
    let sid: String
    let svcid: String
    let cmd: ChzzkChatCmd
    let bdy: [String: Int]

    public var description: String {
        let encoder = JSONEncoder()
        #if DEBUG
            encoder.outputFormatting = .prettyPrinted
        #endif
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }

    public func getData() -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(self)
    }
}

public struct ChzzkPingMessage: ChzzkMessageBodyProtocol {
    public init(_ ver: String, _ tid: Int) {
        self.ver = ver
        self.tid = tid
    }

    public func getData() -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(self)
    }

    public var ver: String
    public var tid: Int
    public var description: String {
        return "Ping"
    }
}

public struct ChzzkBdy: Codable {
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
        self.auth = auth == nil ? "READ" : "WRITE" // TODO: Fix Later
        self.uid = uid ?? "null"
        libVer = "4.9.3"
        osVer = "macOS/10.15.7"
        locale = "ko"
        timezone = "Asia/Seoul"
    }
}

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

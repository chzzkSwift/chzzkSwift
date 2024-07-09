import Foundation

public struct ChatBody: Codable {
    let bdy: ChzzkBdy
    let cmd: Int
    let tid: Int
    let cid: String
    let svcid: String
    let ver: String

    public init(chatAccessToken: String, chatChannelId: String, uid: String?) {
        bdy = ChzzkBdy(accTkn: chatAccessToken, devType: 2001, auth:uid ?? "READ",uid: nil)
        cmd = ChzzkChatCmd.connect.rawValue
        tid = 1
        cid = chatChannelId
        svcid = "game"
        ver = "2"
    }
}

public struct ChzzkBdy: Codable {
    let accTkn: String
    let devType: Int
    let auth: String
    let uid: String?
}

enum ChzzkChatCmd: Int {
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

enum ChzzkChatType: Int {
    case text = 1
    case image = 2
    case sticker = 3
    case video = 4
    case rich = 5
    case donation = 10
    case subscription = 11
    case systemMessage = 30
}

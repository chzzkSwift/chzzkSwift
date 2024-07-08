import Foundation

struct ChatUserInfoResponse: Decodable {
    let code: Int
    let message: String?
    let content: ChatUserInfoContent
}

struct ChatUserInfoContent: Decodable {
    let channelId: String
    let userRole: String
    let permissions: String?
    let following: String?
    let cheatKey: Bool
    let restriction: String?
    let privateUserBlock: Bool
    let subscription: Subscription
    let playerAdFlag: PlayerAdFlag
}

struct Subscription: Decodable {
    let subscribing: Bool
    let subscriptionDeferred: Bool
    let subscriptionAlertNotified: Bool
    let subscriptionDisabled: Bool
}

struct PlayerAdFlag: Decodable {
    let preRoll: Bool
    let midRoll: Bool
    let postRoll: Bool
}

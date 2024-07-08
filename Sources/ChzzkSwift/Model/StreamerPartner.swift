import Foundation

struct StreamerPartnersResponse: Decodable {
    let code: Int
    let message: String?
    let content: StreamerPartnersContent
}

struct StreamerPartnersContent: Decodable {
    let streamerPartners: [StreamerPartner]
}

struct StreamerPartner: Decodable {
    let channelId: String
    let channelImageUrl: String
    let originalNickname: String
    let channelName: String
    let verifiedMark: Bool
    let openLive: Bool
    let newStreamer: Bool
    let liveTitle: String
    let concurrentUserCount: Int
    let liveCategoryValue: String
}

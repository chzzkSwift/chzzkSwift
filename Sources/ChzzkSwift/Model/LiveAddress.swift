import Foundation

struct LiveAddressResponse: Codable {
    let code: Int
    let message: String?
    let content: LiveAddressContent
}

struct LiveAddressContent: Codable {
    let liveId: Int
    let liveTitle: String
    let status: String
    let liveImageUrl: String
    let defaultThumbnailImageUrl: String
    let concurrentUserCount: Int
    let accumulateCount: Int
    let openDate: String
    let closeDate: String?
    let adult: Bool
    let clipActive: Bool
    let tags: [String]
    let chatChannelId: String
    let categoryType: String
    let liveCategory: String
    let liveCategoryValue: String
    let chatActive: Bool
    let chatAvailableGroup: String
    let paidPromotion: Bool
    let chatAvailableCondition: String
    let minFollowerMinute: Int
    let livePlaybackJson: String // m3u8 다운받는 링크 파싱 필요
    let p2pQuality: [String]
    let channel: Channel
    let livePollingStatusJson: String
    let userAdultStatus: String?
    let blindType: String?
    let chatDonationRankingExposure: Bool
    let adParameter: AdParameter
}

struct AdParameter: Codable {
    let tag: String
}

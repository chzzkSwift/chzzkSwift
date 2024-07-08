import Foundation

struct LiveStatusResponse: Codable {
    let code: Int
    let message: String?
    let content: LiveStatus
}

struct LiveStatus: Codable {
    let liveTitle: String
    let status: String
    let concurrentUserCount: Int
    let accumulateCount: Int
    let paidPromotion: Bool
    let adult: Bool
    let krOnlyViewing: Bool
    let clipActive: Bool
    let chatChannelId: String
    let tags: [String]
    let categoryType: String
    let liveCategory: String
    let liveCategoryValue: String
    let livePollingStatusJson: String
    let faultStatus: String?
    let userAdultStatus: String
    let blindType: String?
    let chatActive: Bool
    let chatAvailableGroup: String
    let chatAvailableCondition: String
    let minFollowerMinute: Int
    let chatDonationRankingExposure: Bool
}

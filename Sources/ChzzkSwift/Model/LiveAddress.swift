import Foundation

struct LiveAddressResponse: Decodable {
    let code: Int
    let message: String?
    let content: LiveAddressContent
}

public struct LiveAddressContent: Decodable {
    let liveId: Int
    let liveTitle: String
    let status: String
    let liveImageUrl: String
    let defaultThumbnailImageUrl: String?
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
    let livePlaybackJson: String
    let p2pQuality: [String]
    let channel: Channel
    let livePollingStatusJson: String
    let userAdultStatus: String?
    let blindType: String?
    let chatDonationRankingExposure: Bool
    let adParameter: AdParameter
    func decodeLivePlaybackJson() -> LivePlaybackJson? {
        do {
            let decodedData = try JSONDecoder().decode(LivePlaybackJson.self, from: self.livePlaybackJson.data(using: .utf8)!)
            return decodedData
        } catch {
            print("Failed to decode JSON: \(error)")
        }
        return nil
    }
}

struct AdParameter: Codable {
    let tag: String
}

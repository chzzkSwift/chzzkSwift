import Foundation

struct LiveResponse: Decodable {
    let code: Int
    let message: String?
    let content: LiveContent
}

struct LiveContent: Decodable {
    let topRecommendedLives: [LiveChannel]
}

public struct LiveChannel: Decodable {
    let liveId: Int
    let liveTitle: String
    let liveImageUrl: String
    let defaultThumbnailImageUrl: String?
    let concurrentUserCount: Int
    let tags: [String]
    let categoryType: String
    let liveCategory: String
    let liveCategoryValue: String
    let livePlaybackJson: String
    let channel: LiveChannelInfo
    let livePollingStatusJson: String
    
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

struct LiveChannelInfo: Decodable {
    let channelId: String
    let channelName: String
    let channelImageUrl: String
    let verifiedMark: Bool
}

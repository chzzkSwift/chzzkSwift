import Foundation

struct RecommendationResponse: Decodable {
    let code: Int
    let message: String?
    let content: RecommendationContent
}

struct RecommendationContent: Decodable {
    let recommendationChannels: [RecommendationChannel]
}

struct Streamer: Decodable {
    let openLive: Bool
}

// MARK: - public section

public struct LiveInfo: Decodable {
    let liveTitle: String
    let concurrentUserCount: Int
    let liveCategoryValue: String
}

public struct RecommendationChannel: Decodable {
    let channelId: String
    let channel: Channel
    let streamer: Streamer
    let liveInfo: LiveInfo
    let contentLineage: String
}

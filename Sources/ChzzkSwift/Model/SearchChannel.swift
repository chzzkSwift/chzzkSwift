import Foundation

struct SearchResponse: Decodable {
    let code: Int
    let message: String?
    let content: SearchContent
}

struct SearchContent: Decodable {
    let size: Int
    let page: Page
    let data: [SearchData]
}

struct Page: Decodable {
    let next: Next
}

struct Next: Decodable {
    let offset: Int
}

struct SearchData: Decodable {
    let channel: Channel
    let content: Content?
}

struct Channel: Codable {
    let channelId: String
    let channelName: String
    let channelImageUrl: String?
    let verifiedMark: Bool
    let channelDescription: String?
    let followerCount: Int?
    let openLive: Bool?
}

struct Content: Decodable {
    let live: Live?
    let videos: [Video]?
}

struct Live: Decodable {
    let liveTitle: String
    let liveImageUrl: String
    let defaultThumbnailImageUrl: String?
    let concurrentUserCount: Int
    let accumulateCount: Int
    let openDate: String
    let liveId: Int
    let adult: Bool
    let tags: [String]
    let chatChannelId: String
    let categoryType: String
    let liveCategory: String
    let liveCategoryValue: String
    let channelId: String
    let livePlaybackJson: String
    let blindType: String?
}

struct Video: Decodable {
    let videoNo: Int
    let videoId: String?
    let videoTitle: String
    let videoType: String
    let publishDate: String
    let thumbnailImageUrl: String?
    let duration: Int
    let readCount: Int
    let channelId: String
    let publishDateAt: Int
    let adult: Bool
    let categoryType: String
    let videoCategory: String
    let videoCategoryValue: String
    let blindType: String?
}

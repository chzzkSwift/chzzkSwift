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

// MARK: - 좀 더 알아봐야하는 부분

struct Page: Decodable {
    let next: Next
}

struct Next: Decodable {
    // 기본적으로 offset은 한번에 13식 증가함. 즉, 한페이지에 채널 13개씩 보여줌
    // 사이즈 부분을 건들면 한페이지에 보여지는 채널수를 조절할 수 있음
    // 이에 따라 offset값도 바뀜
    let offset: Int //다음 페이지를 나타낼때 쓰임
}

// MARK: - public section

public struct SearchData: Decodable {
    let channel: Channel
    let content: Content?
}

public struct Channel: Codable {
    let channelId: String
    let channelName: String
    let channelImageUrl: String?
    let verifiedMark: Bool
    let channelDescription: String?
    let followerCount: Int?
    let openLive: Bool?
}

public struct Content: Decodable {
    let live: Live?
    let videos: [Video]?
}

public struct Live: Decodable {
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

public struct Video: Decodable {
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

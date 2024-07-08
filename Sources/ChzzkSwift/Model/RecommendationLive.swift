//
//  File.swift
//  
//
//  Created by 승재 on 7/8/24.
//

import Foundation

struct LiveResponse: Decodable {
    let code: Int
    let message: String?
    let content: LiveContent
}

struct LiveContent: Decodable {
    let topRecommendedLives: [LiveChannel]
}

struct LiveChannel: Decodable {
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
}

struct LiveChannelInfo: Decodable {
    let channelId: String
    let channelName: String
    let channelImageUrl: String
    let verifiedMark: Bool
}

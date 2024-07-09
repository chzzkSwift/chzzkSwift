import Foundation

struct LivePlaybackJson: Decodable {
    let meta: Meta
    let serviceMeta: ServiceMeta
    let live: LiveDate
    let api: [API]
    let media: [Media]
    let thumbnail: Thumbnail
    let multiview: [Multiview]
}

struct Meta: Codable {
    let videoID: String
    let streamSeq: Int
    let liveID: String
    let paidLive: Bool
    let cdnInfo: CdnInfo
    let p2P: Bool
    let cmcdEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case streamSeq
        case liveID = "liveId"
        case paidLive
        case cdnInfo
        case p2P = "p2p"
        case cmcdEnabled
    }
}

// MARK: - CdnInfo
struct CdnInfo: Codable {
    let cdnType: String
    let zeroRating: Bool
}

struct LiveDate: Decodable {
    let start: String
    let open: String
    let timeMachine: Bool
    let status: String
}

struct ServiceMeta: Codable {
    let contentType: String
}

struct API: Codable {
    let name: String
    let path: String
}

struct Media: Codable {
    let mediaID: String
    let protocolType: String
    let path: String
    let encodingTrack: [EncodingTrack]
    let latency: String?

    enum CodingKeys: String, CodingKey {
        case mediaID = "mediaId"
        case protocolType = "protocol"
        case path
        case encodingTrack
        case latency
    }
}

struct EncodingTrack: Codable {
    let encodingTrackID: String
    let videoProfile: String
    let audioProfile: String
    let videoCodec: String
    let videoBitRate: Int
    let audioBitRate: Int
    let videoFrameRate: String
    let videoWidth: Int
    let videoHeight: Int
    let audioSamplingRate: Int
    let audioChannel: Int
    let avoidReencoding: Bool
    let videoDynamicRange: String
    let p2PPath: String?
    let p2PPathUrlEncoding: String?

    enum CodingKeys: String, CodingKey {
        case encodingTrackID = "encodingTrackId"
        case videoProfile
        case audioProfile
        case videoCodec
        case videoBitRate
        case audioBitRate
        case videoFrameRate
        case videoWidth
        case videoHeight
        case audioSamplingRate
        case audioChannel
        case avoidReencoding
        case videoDynamicRange
        case p2PPath = "p2pPath"
        case p2PPathUrlEncoding = "p2pPathUrlEncoding"
    }
}

struct Thumbnail: Codable {
    let snapshotThumbnailTemplate: String
    let types: [String]
}

struct Multiview: Codable {}

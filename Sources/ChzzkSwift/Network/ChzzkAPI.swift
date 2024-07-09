import Alamofire
import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
}

// ChzzkAPI 엔드포인트 정의
enum ChzzkAPI: APIEndpoint {
    case getRecommendationChannels
    case getRecommendedLiveBroadcasts(deviceType: String)
    case getUserStatus
    case getFollowingChannelsLive
    case getRecommendedPartners
    case searchChannels(keyword: String, offset: Int, size: Int, withFirstChannelContent: Bool)
    case getChatUserInfo
    case getLiveStatus(channelId: String)
    case getLiveAddress(channelId: String)
    case getHLSRequest(url: String)
    case getChatAccessToken(chatChannelId: String)
    var baseURL: String {
        switch self {
        case .getUserStatus,
             .getChatAccessToken:
            return "https://comm-api.game.naver.com"
        default:
            return "https://api.chzzk.naver.com"
        }
    }

    var path: String {
        switch self {
        case .getRecommendationChannels:
            return "/service/v1/home/recommendation-channels"
        case .getRecommendedLiveBroadcasts:
            return "/service/v1/home/recommended"
        case .getUserStatus:
            return "/nng_main/v1/user/getUserStatus"
        case .getFollowingChannelsLive:
            return "/service/v1/channels/followings/live"
        case .getRecommendedPartners:
            return "/service/v1/streamer-partners/recommended"
        case .searchChannels:
            return "/service/v1/search/channels"
        case .getChatUserInfo:
            return "/v1.1/chat-user-info"
        case let .getLiveStatus(channelId):
            return "/polling/v3/channels/\(channelId)/live-status"
        case let .getLiveAddress(channelId):
            return "/service/v3/channels/\(channelId)/live-detail"
        case let .getHLSRequest(url):
            return url
        case let .getChatAccessToken(chatChannelId):
            return "/nng_main/v1/chats/access-token?channelId=\(chatChannelId)&chatType=STREAMING"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaders? {
        return [
            "User-Agent": "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36",
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
    }

    var parameters: Parameters? {
        switch self {
        case let .getRecommendedLiveBroadcasts(deviceType):
            return ["deviceType": deviceType]
        case let .searchChannels(keyword, offset, size, withFirstChannelContent):
            return [
                "keyword": keyword, //검색어
                "offset": offset, //페이지
                "size": size, //한번에 보여줄 채널 수
                "withFirstChannelContent": withFirstChannelContent, //첫 채널이 영상 컨텐츠를 보여 줄지 여부
            ]
        default:
            return nil
        }
    }
}

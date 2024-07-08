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
    case getVideoHLSAddress(channelId: String)
    case getHLSRequest(url: String)
    
    var baseURL: String {
        switch self {
        case .getUserStatus:
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
        case .getLiveStatus(let channelId):
            return "/polling/v3/channels/\(channelId)/live-status"
        case .getVideoHLSAddress(let channelId):
            return "/service/v3/channels/\(channelId)/live-detail"
        case .getHLSRequest(let url):
            return url
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return [
            "User-Agent": "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var parameters: Parameters? {
        switch self {
        case .getRecommendedLiveBroadcasts(let deviceType):
            return ["deviceType": deviceType]
        case .searchChannels(let keyword, let offset, let size, let withFirstChannelContent):
            return [
                "keyword": keyword,
                "offset": offset,
                "size": size,
                "withFirstChannelContent": withFirstChannelContent
            ]
        default:
            return nil
        }
    }
}

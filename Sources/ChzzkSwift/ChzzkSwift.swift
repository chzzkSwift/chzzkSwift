import Alamofire
import Starscream

@available(macOS 10.15, *)
public class ChzzkSwift {
    private let apiClient: APIClient

    public init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
        print("chzzkSwift initialized")
    }

    public func getRecommendationChannels() async throws -> [RecommendationChannel] {
        let endpoint = ChzzkAPI.getRecommendationChannels
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(endpoint: endpoint) { (result: Result<RecommendationResponse, AFError>) in
                switch result {
                case let .success(data):
                    if data.code != 200 {
                        continuation.resume(throwing: ChzzkError.error(code: data.code, message: data.message!))
                    }
                    continuation.resume(returning: data.content.recommendationChannels)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func searchChannels(_ channelName: String, offset: Int = 0, size: Int = 13) async throws -> [SearchData] {
        let endpoint = ChzzkAPI.searchChannels(keyword: channelName, offset: 0, size: 13, withFirstChannelContent: true)
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(endpoint: endpoint) { (result: Result<SearchResponse, AFError>) in
                switch result {
                case let .success(data):
                    if data.code != 200 {
                        continuation.resume(throwing: ChzzkError.error(code: data.code, message: data.message!))
                    }
                    continuation.resume(returning: data.content.data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func getRecommendedLiveBroadcasts(deviceType: String) async throws -> [LiveChannel] {
        let endpoint = ChzzkAPI.getRecommendedLiveBroadcasts(deviceType: deviceType)
        
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(endpoint: endpoint) { (result: Result<LiveResponse, AFError>) in
                switch result {
                case let .success(data):
                    if data.code != 200 {
                        continuation.resume(throwing: ChzzkError.error(code: data.code, message: data.message!))
                    } else {
                        continuation.resume(returning: data.content.topRecommendedLives)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func getLiveAddress(channelId: String) async throws -> LiveAddressContent {
        let endpoint = ChzzkAPI.getLiveAddress(channelId: channelId)
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(endpoint: endpoint) { (result: Result<LiveAddressResponse, AFError>) in
                switch result {
                case let .success(data):
                    if data.code != 200 {
                        continuation.resume(throwing: ChzzkError.error(code: data.code, message: data.message!))
                    } else {
                        continuation.resume(returning: data.content)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    public func getLiveStatus(_ channelId: String) async throws -> LiveStatus {
        let endpoint: ChzzkAPI = ChzzkAPI.getLiveStatus(channelId: channelId)
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(endpoint: endpoint) { (result: Result<LiveStatusResponse, AFError>) in
                switch result {
                case let .success(data):
                    if data.code != 200 {
                        continuation.resume(throwing: ChzzkError.error(code: data.code, message: data.message!))
                    }
                    continuation.resume(returning: data.content)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
  
/*
    public func getChatAccessToken(_ chatChannelId: String) async throws {
        let endpoint: ChzzkAPI = ChzzkAPI.getChatAccessToken(chatChannelId: chatChannelId)
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(endpoint: endpoint) { (result: Result<ChatAccessTokenResponse, AFError>) in
                switch result {
                case let .success(data):
                    if data.code != 200 {
                        continuation.resume(throwing: ChzzkError.error(code: data.code, message: data.message!))
                    }
                    continuation.resume(returning: data.content.accessToken)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }

    }*/

    public func connectChat(_ chatChannelId: String) {
        let websocket = ChzzkChatWebSocket(chatChannelId: chatChannelId)

        websocket.connect()

    }
}

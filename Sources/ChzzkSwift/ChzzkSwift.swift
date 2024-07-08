import Alamofire
import Starscream

public class ChzzkSwift {
    private let apiClient: APIClient
    
    public init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
        print("chzzkSwift initialized")
    }

    public func getRecommendationChannels() {
        let endpoint = ChzzkAPI.getRecommendationChannels
        apiClient.request(endpoint: endpoint) { (result: Result<RecommendationResponse, AFError>) in
            switch result {
            case .success(let data):
                print("Recommendation Channels: \(data)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

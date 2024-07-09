import Alamofire
import Foundation

public class APIClient {
    public static let shared = APIClient()

    private init() {}

    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = endpoint.baseURL + endpoint.path
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters, headers: endpoint.headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}

import Alamofire
import Foundation

public class ChzzkAPI {
    private var session: Session
    private var constant: ChzzkAPIConstant
    public init() {
        constant = ChzzkAPIConstant()

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 요청 타임아웃 설정
        configuration.headers = constant.defaultHeaders 
        session = Session(configuration: configuration)
    }

    
    func recommandListRequest() {

    }


    func searchRequest(query: String) async throws {
    }
}

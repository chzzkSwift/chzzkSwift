import Alamofire

public class ChzzkAPI {
    func request() {
        _ = AF.request("", method: .get)
    }
}

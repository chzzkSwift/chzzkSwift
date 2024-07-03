import Alamofire
import Foundation

public struct ChzzkAPIConstant {


    internal var baseURL: String {
        return "https://api.chzzk.naver.com"
    }
    
    internal var defaultHeaders: HTTPHeaders {
        return [
            "User-Agent": "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36",
            "Content-Type": "application/json",
            "Accept": "application/json", 
        ]
    }
}
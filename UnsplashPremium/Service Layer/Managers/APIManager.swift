


import Foundation
import Alamofire

class APIManager {
    static func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = []
        
        if let authToken = EndPoint.currentUserAccessToken {
            headers["Authorization"] = "Bearer" + " " + authToken
        }
        
        return headers
    }
}

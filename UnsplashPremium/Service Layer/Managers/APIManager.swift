//
//  APIManager.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import Foundation
import Alamofire

class APIManager {

    static func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = []

        if let authToken = UserDefaults.standard.string(forKey: DefaultKeys.currentUserAccessTokenKey) {
            headers["Authorization"] = "Bearer" + " " + authToken
        }

        return headers
    }
}

//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol PrivateUserService {
    func getAccessToken(authenticationID: String, result: @escaping (Result<AccessToken, Error>) -> Void)
    func getUserProfile(result: @escaping (Result<UserProfileWrapper, Error>) -> Void)
    func setUserProfile(thingsToChange: [ThingsToChange: String], result: @escaping (Result<ProfileUpdatable, Error>) -> Void)
}

class PrivateUserServiceImplementation: PrivateUserService {
    func getAccessToken(authenticationID: String, result: @escaping (Result<AccessToken, Error>) -> Void) {
        let urlString = "\(EndPoint.base)oauth/token?redirect_uri=\(EndPoint.redirectURI)&grant_type=authorization_code&client_secret=\(EndPoint.clientSecret)&\(EndPoint.clientIdParameter)&code=\(authenticationID)"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .post, parameters: nil).responseDecodable { (response: DataResponse<AccessToken, AFError>) in
            switch response.result {
            case .success(let elements):
                print("token \(elements)")
                result(.success(elements))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    func getUserProfile(result: @escaping (Result<UserProfileWrapper, Error>) -> Void) {
                guard let accessToken = EndPoint.currentUserAccessToken else {
                    return
                }
                let urlString = "\(EndPoint.baseUrl)me"
                guard let url = URL(string: urlString) else { return }
                var urlRequest = URLRequest(url: url)
                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                    guard let data = data else {
                        result(.failure(error!))
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let responseObject = try decoder.decode(UserProfileWrapper.self, from: data)
                        print(responseObject)
                        result(.success(responseObject))
                    } catch {
                        result(.failure(error))
                    }
                }.resume()

//        let urlString = "\(EndPoint.baseUrl)me"
//        guard let url = URL(string: urlString) else { return }
//        let headers = APIManager.headers()
//        print(headers, urlString)
//        AF.request(url, method: .put, parameters: nil, headers: headers).responseDecodable { (response: DataResponse<UserProfileWrapper, AFError>) in
//            print(String(data: response.data!, encoding: .utf8))
//            switch response.result {
//            case .success(let elements):
//                result(.success(elements))
//            case .failure(let error):
//                result(.failure(error))
//            }
//        }
    }
    func setUserProfile(thingsToChange: [ThingsToChange : String], result: @escaping (Result<ProfileUpdatable, Error>) -> Void) {
        if thingsToChange.isEmpty {
            return
        }
        
        var urlString = "\(EndPoint.baseUrl)me?"
        for (key, value) in thingsToChange {
            urlString.append(contentsOf: "\(key.rawValue)=\(value)&")
        }
        urlString.remove(at: urlString.index(before: urlString.endIndex))
        guard let url = URL(string: urlString) else { return }
        let headers = APIManager.headers()
        
        
        AF.request(url, method: .put, headers: headers).responseDecodable { (response: DataResponse<UserProfileUpdatableWrapper, AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(ProfileUpdatable(profile: elements)))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    
    
    
    //        guard let accessToken = EndPoint.currentUserAccessToken else {
    //            return
    //        }
    //        guard let url = URL(string: urlString) else {
    //            return
    //        }
    //        var urlRequest = URLRequest(url: url)
    //        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    //        urlRequest.httpMethod = "PUT"
    //        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
    //            guard let data = data else {
    //                return
    //            }
    //            let decoder = JSONDecoder()
    //            do {
    //                let responseObject = try decoder.decode(UserProfileUpdatableWrapper.self, from: data)
    //                result(.success(ProfileUpdatable(profile: responseObject)))
    //            } catch {
    //                result(.failure(error))
    //            }
    //        }.resume()
    
}

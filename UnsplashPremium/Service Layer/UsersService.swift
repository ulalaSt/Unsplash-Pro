//
//  UsersService.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import Foundation
import Alamofire

protocol UsersService {
    func searchUsers(query: String, result: @escaping (Result<UsersWrapper, Error>) -> Void)
    func getUserPhotos(username: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getUserLikes(username: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getUserCollections(username: String, result: @escaping (Result<[UserCollectionWrapper], Error>) -> Void)
    func getUserProfile(username: String, result: @escaping (Result<UserProfileWrapper, Error>) -> Void)
}

class UsersServiceImplementation : UsersService {
    func searchUsers(query: String, result: @escaping (Result<UsersWrapper, Error>) -> Void) {
        let urlString = String(format: "%@search/users/?%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
        guard let url = URL(string: urlString) else { return }
        let parameters: [String: Any] = ["query": query, "per_page": 20]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable { (response: DataResponse<UsersWrapper, AFError>) in
            switch response.result {
            case .success(let users):
                result(.success(users))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getUserPhotos(username: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(format: "%@users/\(username)/photos/?%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[PhotoWrapper], AFError>) in
            switch response.result {
            case .success(let photos):
                result(.success(photos))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getUserLikes(username: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(format: "%@users/\(username)/likes/?%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[PhotoWrapper], AFError>) in
            switch response.result {
            case .success(let photos):
                result(.success(photos))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getUserCollections(username: String, result: @escaping (Result<[UserCollectionWrapper], Error>) -> Void) {
        let urlString = String(format: "%@users/\(username)/collections/?%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[UserCollectionWrapper], AFError>) in
            switch response.result {
            case .success(let collections):
                result(.success(collections))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getUserProfile(username: String, result: @escaping (Result<UserProfileWrapper, Error>) -> Void) {
        let urlString = String(format: "%@users/\(username)/?%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<UserProfileWrapper, AFError>) in
            switch response.result {
            case .success(let user):
                result(.success(user))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

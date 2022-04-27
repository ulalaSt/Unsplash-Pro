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
}

class UsersServiceImplementation : UsersService {
    func searchUsers(query: String, result: @escaping (Result<UsersWrapper, Error>) -> Void) {
        let urlString = String(format: "%@search/users%@", EndPoint.baseUrl,EndPoint.clientIdParameter)
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
}

//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol RecommendationService {
    func getPhotosToDiscover( result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
}

class RecommendationServiceImplementation: RecommendationService {
    
    func getPhotosToDiscover( result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@photos/random/?count=30&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }
        print(urlString)
        let headers = APIManager.headers()
        print(headers, "  and  ", urlString)
        AF.request(url, method: .get, headers: headers).responseDecodable { (response: DataResponse<[PhotoWrapper], AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

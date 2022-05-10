//
//  SearchPhotosService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol SearchService {
    func getRandomPhoto(for query: String, result: @escaping (Result<PhotoWrapper, Error>) -> Void)
    func getRandomPhoto(result: @escaping (Result<PhotoWrapper, Error>) -> Void)
}


class SearchServiceImplementation: SearchService {
    func getRandomPhoto(result: @escaping (Result<PhotoWrapper, Error>) -> Void) {
        let urlString = String(
            format: "%@photos/random/?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }

        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<PhotoWrapper, AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getRandomPhoto(for query: String, result: @escaping (Result<PhotoWrapper, Error>) -> Void) {
        
        let urlString = String(
            format: "%@photos/random/?query=\(query)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter2
        ).replacingOccurrences(of: " ", with: "%20")

        guard let url = URL(string: urlString) else { return }

        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<PhotoWrapper, AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
}

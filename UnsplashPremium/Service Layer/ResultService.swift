//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol SearchResultService {
    func getSearchedPhotos(for query: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
}

class SearchResultServiceImplementation: SearchResultService {
    func getSearchedPhotos(for query: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@search/photos/?query=\(query)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }

        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[PhotoWrapper], AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
}

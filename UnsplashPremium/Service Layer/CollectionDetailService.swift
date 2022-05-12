//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol CollectionDetailService {
    func getCollectionPhotos( with id: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
}

class CollectionDetailServiceImplementation: CollectionDetailService {
    
    func getCollectionPhotos( with id: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@collections/\(id)/photos/?page=\(page)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }
        print(urlString)
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

//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol UserDetailService {
    func getUserPhotos( with id: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getUserLikedPhotos( with id: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getUserCollections( with id: String, page: Int, result: @escaping (Result<[CollectionWrapper], Error>) -> Void)
}

class UserDetailServiceImplementation: UserDetailService {
    func getUserPhotos(with username: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@users/\(username)/photos/?page=\(page)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter )
        guard let url = URL(string: urlString) else { return }
        
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

//        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[PhotoWrapper], AFError>) in
//            switch response.result {
//            case .success( let photos):
//                result(.success(photos))
//            case .failure(let error):
//                result(.failure(error))
//            }
//        }
    }
    
    func getUserLikedPhotos(with username: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@users/\(username)/likes/?page=\(page)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter )
        guard let url = URL(string: urlString) else { return }
        
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
    
    func getUserCollections(with username: String, page: Int, result: @escaping (Result<[CollectionWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@users/\(username)/collections/?page=\(page)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter )
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get).responseDecodable { (response: DataResponse<[CollectionWrapper], AFError>) in
            switch response.result {
            case .success(let elements):
                print("This are elements: \(elements)")
                result(.success(elements))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

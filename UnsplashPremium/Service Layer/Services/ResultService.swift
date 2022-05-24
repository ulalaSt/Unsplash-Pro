//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol SearchResultService {
    func getSearchedPhotos(for query: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getSearchedCollections(for query: String, page: Int, result: @escaping (Result<[CollectionWrapper], Error>) -> Void)
    func getSearchedUsers(for query: String, page: Int, result: @escaping (Result<[UserWrapper], Error>) -> Void)
}

class SearchResultServiceImplementation: SearchResultService {
    
    func getSearchedPhotos(for query: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@search/photos/?page=\(page)&per_page=30&query=\(query)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        ).replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlString) else { return }
        print(urlString)
        let headers = APIManager.headers()
        AF.request(url, method: .get, headers: headers).responseDecodable { (response: DataResponse<ResultWrapper, AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements.results))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getSearchedCollections(for query: String, page: Int, result: @escaping (Result<[CollectionWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@search/collections/?page=\(page)&per_page=30&query=\(query)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }
        print(urlString)
        let headers = APIManager.headers()
        AF.request(url, method: .get, headers: headers).responseDecodable { (response: DataResponse<CollectionResult, AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements.results))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func getSearchedUsers(for query: String, page: Int, result: @escaping (Result<[UserWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@search/users/?page=\(page)&per_page=30&query=\(query)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }
        print(urlString)
        let headers = APIManager.headers()
        AF.request(url, method: .get, headers: headers).responseDecodable { (response: DataResponse<UsersResult, AFError>) in
            switch response.result {
            case .success(let elements):
                result(.success(elements.results))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
}

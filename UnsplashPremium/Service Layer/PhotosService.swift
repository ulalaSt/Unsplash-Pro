//
//  Network.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import Foundation
import Alamofire
import AlamofireImage

protocol PhotosService {
    func getEditorialPhotos(result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getPhotosForTopic(topicID: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getAllTopics(result: @escaping (Result<[TopicWrapper], Error>) -> Void)
}

class PhotosServiceImplementation: PhotosService {
    func getEditorialPhotos(result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(format: "%@photos%@", EndPoint.baseUrl,EndPoint.clientIdParameter)
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
    
    func getPhotosForTopic(topicID: String, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(format: "%@topics/\(topicID)/photos%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
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
    
    func getAllTopics(result: @escaping (Result<[TopicWrapper], Error>) -> Void) {
        let urlString = String(format: "%@topics%@", EndPoint.baseUrl, EndPoint.clientIdParameter)
        guard let url = URL(string: urlString) else { return }
                
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[TopicWrapper], AFError>) in
            switch response.result {
            case .success(let topics):
                result(.success(topics))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    static func getImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        AF.request(url, method: .get).responseImage { (response) in
            switch response.result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

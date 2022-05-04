
import UIKit
import Alamofire
import AlamofireImage

protocol PhotosService {
    func getEditorialPhotos(result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getPhotosForTopic(topicID: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getAllTopics(result: @escaping (Result<[TopicWrapper], Error>) -> Void)
    static func getSinglePhoto(with id: String, completion: @escaping (Result<PhotoDetailedWrapper, Error>) -> Void)
}

class PhotosServiceImplementation: PhotosService {
    
    func getEditorialPhotos(result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        
        let urlString = String(
            format: "%@photos/?%@",
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
    
    func getPhotosForTopic(topicID: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        
        let urlString = String(
            format: "%@topics/\(topicID)/photos?page=\(page)&%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else {
            print("Error: URL issue on getPhotosForTopic")
            return
        }
        
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
        
        let urlString = String(
            format: "%@topics/?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
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
    
    static func getSinglePhoto(with id: String, completion: @escaping (Result<PhotoDetailedWrapper, Error>) -> Void){
        
        let urlString = String(
            format: "%@photos/\(id)?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<PhotoDetailedWrapper, AFError>) in
            switch response.result {
            case .success(let element):
                completion(.success(element))
            case .failure(let error):
                completion(.failure(error))
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

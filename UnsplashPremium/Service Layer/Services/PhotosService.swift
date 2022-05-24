


import UIKit
import Alamofire
import AlamofireImage

protocol PhotosService {
    func getEditorialPhotos(result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getPhotosForTopic(topicID: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void)
    func getAllTopics(result: @escaping (Result<[TopicWrapper], Error>) -> Void)
    static func getSinglePhoto(with id: String, completion: @escaping (Result<PhotoDetailedWrapper, Error>) -> Void)
    func saveImage(image: UIImage?, name: String) -> Bool
}

class PhotosServiceImplementation: PhotosService {
    
    func getEditorialPhotos(result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        let urlString = String(
            format: "%@photos/?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
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
    
    func getPhotosForTopic(topicID: String, page: Int, result: @escaping (Result<[PhotoWrapper], Error>) -> Void) {
        
        let parameters: Parameters = ["page" : "\(page)"]
        let urlString = String(
            format: "%@topics/\(topicID)/photos?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )
        guard let url = URL(string: urlString) else {
            print("Error: URL issue on getPhotosForTopic")
            return
        }
        
        let headers = APIManager.headers()
        print(headers, "  and  ", urlString)
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable { (response: DataResponse<[PhotoWrapper], AFError>) in
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
        
        print(urlString)
        AF.request(url, method: .get, parameters: nil).responseDecodable { (response: DataResponse<[TopicWrapper], AFError>) in
            switch response.result {
            case .success(let topics):
                result(.success(topics))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func saveImage(image: UIImage?, name: String) -> Bool {
        guard let image = image, let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func getSinglePhoto(with id: String, completion: @escaping (Result<PhotoDetailedWrapper, Error>) -> Void){
        let urlString = String(
            format: "%@photos/\(id)?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )

        guard let url = URL(string: urlString) else {
            return
        }
        let headers = APIManager.headers()
        
        AF.request(url, method: .get, headers: headers).responseDecodable { (response: DataResponse<PhotoDetailedWrapper, AFError>) in
            switch response.result {
            case .success(let elements):
                completion(.success(elements))
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

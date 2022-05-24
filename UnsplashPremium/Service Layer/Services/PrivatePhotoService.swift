//
//  ResultsService.swift
//  UnsplashPremium
//
//  Created by user on 09.05.2022.
//

import Foundation
import Alamofire

protocol PrivatePhotoService {
    func likePhoto(with id: String)
    func dislikePhoto(with id: String)
}

class PrivatePhotoServiceImplementation: PrivatePhotoService {
    func likePhoto(with id: String){
        let urlString = String(
            format: "%@photos/\(id)/like?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )

        guard let url = URL(string: urlString) else {
            return
        }
        let headers = APIManager.headers()
        print(headers, "  and  ", urlString)
        AF.request(url, method: .post, headers: headers).resume()
    }
    func dislikePhoto(with id: String){
        let urlString = String(
            format: "%@photos/\(id)/like?%@",
            EndPoint.baseUrl,
            EndPoint.clientIdParameter
        )

        guard let url = URL(string: urlString) else {
            return
        }
        let headers = APIManager.headers()
        print(headers, "  and  ", urlString)
        AF.request(url, method: .delete, headers: headers).resume()
    }
}

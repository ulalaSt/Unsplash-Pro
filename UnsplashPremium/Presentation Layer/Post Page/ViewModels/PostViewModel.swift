//
//  PostViewModel.swift
//  UnsplashPremium
//
//  Created by user on 16.05.2022.
//

import Foundation

class PostViewModel {
    
    private let photosService: PhotosService
    
    // initializer
    init(photosService: PhotosService) {
        self.photosService = photosService
    }
    
    
    // actions after request
    var didLoadTopics: (([TopicWrapper]) -> Void)?

    func getAllTopics() {
        photosService.getAllTopics {[weak self] result in
            switch result {
            case .success(let topics):
                self?.didLoadTopics?(topics)
            case .failure(let error):
                print("Failed to load topics with error: \(error.localizedDescription)")
            }
        }
    }
}

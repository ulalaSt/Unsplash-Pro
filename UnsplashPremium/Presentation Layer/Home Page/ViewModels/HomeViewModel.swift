//
//  HomeViewModel.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import Foundation

class HomeViewModel {
    private let photosService: PhotosService
    
    var didLoadTopics: (([TopicWrapper]) -> Void)?

    var didLoadEditorialPhotos: (([PhotoWrapper]) -> Void)?
    
    var didLoadPhotosForTopic: (([PhotoWrapper]) -> Void)?
    
    init(photosService: PhotosService) {
        self.photosService = photosService
    }
    
    func getEditorialPhotos() {
        photosService.getEditorialPhotos {[weak self] result in
            switch result {
            case .success(let photos):
                self?.didLoadEditorialPhotos?(photos)
            case .failure(_):
                print("Failed to load photos")
            }
        }
    }
    func getAllTopics() {
        photosService.getAllTopics {[weak self] result in
            switch result {
            case .success(let topics):
                self?.didLoadTopics?(topics)
                print(topics)
            case .failure(let error):
                print("Failed to load topics with error: \(error.localizedDescription)")
            }
        }
    }
}

//
//  UserDetailViewModel.swift
//  UnsplashPremium
//
//  Created by user on 12.05.2022.
//

import Foundation

class UserDetailViewModel {
    private let resultsService: UserDetailService
    
    // initializer
    init(resultsService: UserDetailService) {
        self.resultsService = resultsService
    }
    
    
    // actions after request
    var didLoadUserPhotos: (([Photo]) -> Void)?
    var didLoadAdditionalUserPhotos: (([Photo]) -> Void)?
    
    var didLoadUserLikes: (([Photo]) -> Void)?
    var didLoadAdditionalUserLikes: (([Photo]) -> Void)?
    
    var didLoadUserCollections: (([Collection]) -> Void)?
    var didLoadAdditionalUserCollections: (([Collection]) -> Void)?

    func getUserPhotos(username: String, page: Int) {
        resultsService.getUserPhotos(with: username, page: page) { result in
            switch result {
            case .success( let photos):
                if page == 1 {
                    self.didLoadUserPhotos?(photos.map({  Photo(wrapper: $0) }))
                } else {
                    self.didLoadAdditionalUserPhotos?(photos.map({  Photo(wrapper: $0) }))
                }
            case .failure(let error):
                print("Error on loading Searched Photos: \(error.localizedDescription)")
            }
        }
    }
    func getUserLikes(username: String, page: Int){
        resultsService.getUserLikedPhotos(with: username, page: page) { result in
            switch result {
            case .success( let photos):
                if page == 1 {
                    self.didLoadUserLikes?(photos.map({  Photo(wrapper: $0) }))
                } else {
                    self.didLoadAdditionalUserLikes?(photos.map({  Photo(wrapper: $0) }))
                }
            case .failure(let error):
                print("Error on loading Searched Photos: \(error.localizedDescription)")
            }
        }
    }
    func getUserCollections(username: String, page: Int){
        resultsService.getUserCollections(with: username, page: page) { result in
            switch result {
            case .success( let collections):
                if page == 1 {
                    self.didLoadUserCollections?(collections.map({  Collection(wrapper: $0) }))
                } else {
                    self.didLoadAdditionalUserCollections?(collections.map({  Collection(wrapper: $0) }))
                }
            case .failure(let error):
                print("Error on loading Searched Photos: \(error.localizedDescription)")
            }
        }
    }
}

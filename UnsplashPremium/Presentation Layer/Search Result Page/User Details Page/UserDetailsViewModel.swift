//
//  UserDetailsViewModel.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 30.04.2022.
//

import Foundation

class UserDetailsViewModel {
    private let usersService: UsersService
    
    var didLoadUserPhotos: (([PhotoWrapper]) -> Void)?
    var didLoadUserLikes: (([PhotoWrapper]) -> Void)?
    var didLoadUserCollections: (([UserCollectionWrapper]) -> Void)?
    var didLoadUserProfile: ((UserProfileWrapper) -> Void)?
    
    init(usersService: UsersService) {
        self.usersService = usersService
    }
    
    func getUserPhotos(username: String) {
        usersService.getUserPhotos(username: username) {[weak self] result in
            switch result {
                case .success(let photos):
                    self?.didLoadUserPhotos?(photos)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getUserLikes(username: String) {
        usersService.getUserLikes(username: username) {[weak self] result in
            switch result {
                case .success(let photos):
                    self?.didLoadUserLikes?(photos)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getUserCollections(username: String) {
        usersService.getUserCollections(username: username) {[weak self] result in
            switch result {
                case .success(let collections):
                    self?.didLoadUserCollections?(collections)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getUserProfile(username: String) {
        usersService.getUserProfile(username: username) {[weak self] result in
            switch result {
                case .success(let user):
                    self?.didLoadUserProfile?(user)
                case .failure(let error):
                    print(error)
            }
        }
    }
}

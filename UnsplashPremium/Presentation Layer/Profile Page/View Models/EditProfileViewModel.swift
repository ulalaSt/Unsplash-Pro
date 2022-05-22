//
//  EditProfileViewModel.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import Foundation

class EditProfileViewModel {
    private let service: PrivateUserService
    
    init(service: PrivateUserService){
        self.service = service
    }
    var didChangeUserProfile: ((Result<ProfileUpdatable, Error>)->Void)?

    func postUpdatedUserProfile(with thingsToChange: [ThingsToChange: String]){
        print(thingsToChange)
        service.setUserProfile(thingsToChange: thingsToChange) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.didChangeUserProfile?(.success(profile))
            case .failure(let error):
                self?.didChangeUserProfile?(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
}

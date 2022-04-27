//
//  SearchResultViewModel.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import Foundation

class SearchResultViewModel {
    private let usersService: UsersService
    
    var didLoadUsers: ((UsersWrapper) -> Void)?
    
    init(usersService: UsersService) {
        self.usersService = usersService
    }
    
    func searchUsers(query: String) {
        usersService.searchUsers(query: query) {[weak self] result in
            switch result {
                case .success(let usersWrapper):
                    self?.didLoadUsers?(usersWrapper)
                case .failure(let error):
                    print(error)
            }
        }
    }
}

//
//  ResultViewModel.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import Foundation

class UserResultViewModel {
    private let resultsService: SearchResultService
    
    // initializer
    init(resultsService: SearchResultService) {
        self.resultsService = resultsService
    }
    
    
    // actions after request
    var didLoadSearchedUsers: (([UserWrapper]) -> Void)?
    var didLoadAdditionalSearchedUsers: (([UserWrapper]) -> Void)?

    func getSearchedUsers(for query: String, page: Int) {
        resultsService.getSearchedUsers(for: query, page: page) { result in
            switch result {
            case .success( let photos):
                if page == 1 {
                    self.didLoadSearchedUsers?(photos)
                } else {
                    self.didLoadAdditionalSearchedUsers?(photos)
                }
            case .failure(let error):
                print("Error on loading Searched Photos: \(error.localizedDescription)")
            }
        }
    }
}

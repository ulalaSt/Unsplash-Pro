//
//  ResultViewModel.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import Foundation

class CollectionResultViewModel {
    private let resultsService: SearchResultService
    
    // initializer
    init(resultsService: SearchResultService) {
        self.resultsService = resultsService
    }
    
    
    // actions after request
    var didLoadSearchedCollections: (([Collection]) -> Void)?
    var didLoadAdditionalSearchedCollections: (([Collection]) -> Void)?

    func getSearchedCollections(for query: String, page: Int) {
        resultsService.getSearchedCollections(for: query, page: page) { result in
            switch result {
            case .success( let collections):
                if page == 1 {
                    self.didLoadSearchedCollections?(collections.map({  Collection(wrapper: $0) }))
                } else {
                    self.didLoadAdditionalSearchedCollections?(collections.map({  Collection(wrapper: $0) }))
                }
            case .failure(let error):
                print("Error on loading Searched Collections: \(String(describing: error))")
            }
        }
    }
}

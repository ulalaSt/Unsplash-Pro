//
//  ResultViewModel.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import Foundation

class CollectionDetailViewModel {
    private let resultsService: CollectionDetailService
    
    // initializer
    init(resultsService: CollectionDetailService) {
        self.resultsService = resultsService
    }
    
    
    // actions after request
    var didLoadCollectionPhotos: (([Photo]) -> Void)?
    var didLoadAdditionalCollectionPhotos: (([Photo]) -> Void)?

    func getSearchedCollections(id: String, page: Int) {
        resultsService.getCollectionPhotos(with: id, page: page) { result in
            switch result {
            case .success( let collections):
                if page == 1 {
                    self.didLoadCollectionPhotos?(collections.map({  Photo(wrapper: $0) }))
                } else {
                    self.didLoadAdditionalCollectionPhotos?(collections.map({  Photo(wrapper: $0) }))
                }
            case .failure(let error):
                print("Error on loading Searched Photos: \(error.localizedDescription)")
            }
        }
    }
}

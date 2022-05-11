//
//  ResultViewModel.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import Foundation

class PhotoResultViewModel {
    private let resultsService: SearchResultService
    
    // initializer
    init(resultsService: SearchResultService) {
        self.resultsService = resultsService
    }
    
    
    // actions after request
    var didLoadSearchedPhotos: (([Photo]) -> Void)?
    var didLoadAdditionalSearchedPhotos: (([Photo]) -> Void)?

    func getSearchedPhotos(for query: String, page: Int) {
        resultsService.getSearchedPhotos(for: query, page: page) { result in
            switch result {
            case .success( let photos):
                if page == 1 {
                    self.didLoadSearchedPhotos?(photos.map({  Photo(wrapper: $0) }))
                } else {
                    self.didLoadAdditionalSearchedPhotos?(photos.map({  Photo(wrapper: $0) }))
                }
            case .failure(let error):
                print("Error on loading Searched Photos: \(error.localizedDescription)")
            }
        }
    }
}

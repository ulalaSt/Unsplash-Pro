//
//  SearchRecommendationViewModel.swift
//  UnsplashPremium
//
//  Created by user on 11.05.2022.
//

import Foundation

class SearchRecommendationViewModel {
    private let resultsService: RecommendationService
    
    // initializer
    init(resultsService: RecommendationService) {
        self.resultsService = resultsService
    }
    
    let categories: [Category] = [
        Category(title: "Nature",
                 imageUrl: "https://images.unsplash.com/photo-1469474968028-56623f02e42e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMjE5MDF8MHwxfHNlYXJjaHwyfHxuYXR1cmV8ZW58MHx8fHwxNjUyMjQ4ODMy&ixlib=rb-1.2.1&q=80&w=400"),
        Category(title: "Textures",
                 imageUrl: "https://images.unsplash.com/photo-1507214617719-4a3daf41b9ac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMjE5MDF8MHwxfHNlYXJjaHwzfHx0ZXh0dXJlc3xlbnwwfHx8fDE2NTIyNDg5NDE&ixlib=rb-1.2.1&q=80&w=400"),
        Category(title: "Black and White",
                 imageUrl: "https://images.unsplash.com/photo-1498335746477-0c73d7353a07?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMjE5MDF8MHwxfHNlYXJjaHw3fHxibGFjayUyMGFuZCUyMHdoaXRlfGVufDB8fHx8MTY1MjI0OTA4NQ&ixlib=rb-1.2.1&q=80&w=400"),
        Category(title: "Space",
                 imageUrl: "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8NnwxMzYzMDF8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Abstract",
                 imageUrl: "https://images.unsplash.com/photo-1618005198919-d3d4b5a92ead?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fGFic3RyYWN0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Minimal",
                 imageUrl: "https://images.unsplash.com/photo-1506619216599-9d16d0903dfd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bWluaW1hbHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Animals",
                 imageUrl: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YW5pbWFsc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Sky",
                 imageUrl: "https://images.unsplash.com/photo-1513002749550-c59d786b8e6c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80"),
        Category(title: "Flowers",
                 imageUrl: "https://images.unsplash.com/photo-1490750967868-88aa4486c946?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Zmxvd2Vyc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Travel",
                 imageUrl: "https://images.unsplash.com/photo-1504150558240-0b4fd8946624?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8dHJhdmVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Underwater",
                 imageUrl: "https://images.unsplash.com/photo-1560364897-91578ff41817?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dW5kZXJ3YXRlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Drones",
                 imageUrl: "https://images.unsplash.com/photo-1557343569-b1d5b655b7cb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZHJvbmVzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Architecture",
                 imageUrl: "https://images.unsplash.com/photo-1511818966892-d7d671e672a2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8YXJjaGl0ZWN0dXJlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
        Category(title: "Gradients",
                 imageUrl: "https://images.unsplash.com/photo-1604076913837-52ab5629fba9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z3JhZGllbnRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
    ]
    
    // actions after request
    var didLoadDiscoveryPhotos: (([Photo]) -> Void)?
    
    func getDiscoveryPhotos() {
        resultsService.getPhotosToDiscover { result in
            switch result {
            case .success( let photoWrappers):
                let photos = photoWrappers.map { Photo(wrapper: $0) }
                self.didLoadDiscoveryPhotos?(photos)
            case .failure(let error):
                print("Error on loading Discovery Photos: \(error.localizedDescription)")
            }
            
        }
    }
}

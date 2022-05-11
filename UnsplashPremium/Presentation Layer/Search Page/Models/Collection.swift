//
//  Collection.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import Foundation

struct Collection {
    let id: String
    let title: String
    let smallUrl: String
    let regularUrl: String
    
    init(wrapper: CollectionWrapper) {
        self.id = wrapper.id
        self.title = wrapper.title
        self.smallUrl = wrapper.coverPhoto.urls.small
        self.regularUrl = wrapper.coverPhoto.urls.regular
    }
    init(id: String, title: String, smallUrl: String, regularUrl: String) {
        self.id = id
        self.title = title
        self.smallUrl = smallUrl
        self.regularUrl = regularUrl
    }
}

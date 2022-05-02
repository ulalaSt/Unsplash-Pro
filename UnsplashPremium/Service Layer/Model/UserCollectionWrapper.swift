//
//  UserCollectionsWrapper.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 02.05.2022.
//

import Foundation

struct UserCollectionWrapper: Codable {
    let title: String
    let coverPhoto: CoverPhotoWrapper
    
    enum CodingKeys: String, CodingKey {
        case title
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhotoWrapper: Codable {
    let urls: CoverPhotoUrlsWrapper
    
    enum CodingKeys: String, CodingKey {
        case urls
    }
}

struct CoverPhotoUrlsWrapper: Codable {
    let regular: String
    
    enum CodingKeys: String, CodingKey {
        case regular
    }
}

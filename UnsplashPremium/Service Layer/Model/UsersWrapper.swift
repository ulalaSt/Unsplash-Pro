//
//  UserWrapper.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import Foundation

struct UsersResult: Codable {
    let total: Int
    let results: [UserWrapper]
    
    enum CodingKeys: String, CodingKey {
        case total
        case results
    }
}

struct UserWrapper: Codable {
    let username: String
    let name: String
    let profileImageUrl: UserProfileImageWrapper
    let location: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case name
        case profileImageUrl = "profile_image"
        case location
        case website = "portfolio_url"
    }
}

struct UserProfileImageWrapper: Codable {
    let mediumImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case mediumImageUrl = "medium"
    }
}

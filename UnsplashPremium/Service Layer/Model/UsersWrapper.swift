//
//  UserWrapper.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import Foundation

struct UsersWrapper: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case username
        case name
        case profileImageUrl = "profile_image"
    }
}

struct UserProfileImageWrapper: Codable {
    let mediumImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case mediumImageUrl = "medium"
    }
}

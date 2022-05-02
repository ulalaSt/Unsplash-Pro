//
//  User.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import Foundation

struct User {
    let username: String
    let name: String
    let bio: String
    let location: String?
    let portfolioURL: String?
    let profileImageURL: ProfileImageURL
    
    struct ProfileImageURL {
        let small, medium, large: String
    }
}


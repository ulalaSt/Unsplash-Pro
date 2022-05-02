//
//  UserProfileWrapper.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 02.05.2022.
//

import Foundation

import Foundation

struct UserProfileWrapper: Codable {
    let location: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case location
        case website = "portfolio_url"
    }
}

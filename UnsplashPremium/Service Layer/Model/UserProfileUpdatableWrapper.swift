//
//  UserProfileUpdatableWrapper.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import Foundation

struct UserProfileUpdatableWrapper: Codable {
    let id: String
    let username, firstName, lastName: String
    let twitterUsername, portfolioURL, bio, location: String?
    let totalLikes, totalPhotos, totalCollections: Int
    let followedByUser: Bool
    let downloads, uploadsRemaining: Int
    let instagramUsername: String?
    let email: String
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case downloads
        case uploadsRemaining = "uploads_remaining"
        case instagramUsername = "instagram_username"
        case email, links
    }
}

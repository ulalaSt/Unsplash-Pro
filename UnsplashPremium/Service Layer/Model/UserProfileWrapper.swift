//
//  UserProfileWrapper.swift
//  UnsplashPremium
//
//  Created by user on 20.05.2022.
//

import Foundation

// MARK: - UserProfile
struct UserProfileWrapper: Codable {
    let id: String
    let username, name, firstName, lastName: String
    let twitterUsername, portfolioURL, bio, location: String?
    let links: Links
    let profileImage: ProfileImage
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos: Int
    let acceptedTos, forHire: Bool
    let followedByUser: Bool
    let photos: [PhotoWrapper]
    let followersCount, followingCount: Int
    let allowMessages: Bool
    let numericID, downloads: Int
    let meta: Meta
    let uid: String
    let confirmed: Bool
    let uploadsRemaining: Int
    let unlimitedUploads: Bool
    let email, dmcaVerification: String
    let unreadInAppNotifications: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
        case followedByUser = "followed_by_user"
        case photos
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case allowMessages = "allow_messages"
        case numericID = "numeric_id"
        case downloads, meta, uid, confirmed
        case uploadsRemaining = "uploads_remaining"
        case unlimitedUploads = "unlimited_uploads"
        case email
        case dmcaVerification = "dmca_verification"
        case unreadInAppNotifications = "unread_in_app_notifications"
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: - Meta
struct Meta: Codable {
    let index: Bool
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}

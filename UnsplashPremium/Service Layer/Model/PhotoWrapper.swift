//
//  Service Models.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import Foundation

struct PhotoWrapper: Codable {
    let id: String
    let createdAt: String
    let width, height: Int
    let color, blurHash: String
    let photoDescription: String?
    let urls: UrlsCodable
    let links: PhotoLinksCodable
    let likes: Int
    let user: UserCodable

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color
        case blurHash = "blur_hash"
        case photoDescription = "description"
        case urls, links, likes
        case user
    }
}

// MARK: - PhotoLinks
struct PhotoLinksCodable: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - User
struct UserCodable: Codable {
    let id: String
    let username, name: String
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let links: UserLinksCodable
    let profileImage: ProfileImageCodable
    let totalCollections, totalLikes, totalPhotos: Int
    let forHire: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case forHire = "for_hire"
    }
}

// MARK: - UserLinks
struct UserLinksCodable: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: - ProfileImage
struct ProfileImageCodable: Codable {
    let small, medium, large: String
}

// MARK: - Urls
struct UrlsCodable: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}





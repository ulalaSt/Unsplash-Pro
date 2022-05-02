//
//  TopicWrapper.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import Foundation

struct TopicWrapper: Codable {
    let id, slug, title, topicDescription: String
    let totalPhotos: Int
    let links: TopicLinksCodable
    let coverPhoto: PhotoWrapper

    enum CodingKeys: String, CodingKey {
        case id, slug, title
        case topicDescription = "description"
        case totalPhotos = "total_photos"
        case links
        case coverPhoto = "cover_photo"
    }
}

// MARK: - TopicLinks
struct TopicLinksCodable: Codable {
    let linksSelf, html, photos: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos
    }
}


//
//  CollectionWrapper.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import Foundation

// MARK: - CollectionWrapper
struct CollectionResult: Codable {
    let total, totalPages: Int
    let results: [CollectionWrapper]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct CollectionWrapper: Codable {
    let id: String
    let title: String
    let totalPhotos: Int
    let coverPhoto: ResultCoverPhoto

    enum CodingKeys: String, CodingKey {
        case id, title
        case totalPhotos = "total_photos"
        case coverPhoto = "cover_photo"
    }
}

// MARK: - ResultCoverPhoto
struct ResultCoverPhoto: Codable {
    let width, height: Int
    let urls: UrlsCodable

    enum CodingKeys: String, CodingKey {
        case width, height
        case urls
    }
}

// MARK: - CoverPhotoLinks
struct CoverPhotoLinks: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

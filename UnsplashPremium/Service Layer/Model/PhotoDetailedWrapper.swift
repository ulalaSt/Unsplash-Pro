//
//  PhotoDetailedWrapper.swift
//  UnsplashPremium
//
//  Created by user on 03.05.2022.
//

import Foundation


// MARK: - PhotoDetailedWrapper


struct PhotoDetailedWrapper: Codable {
    let id: String
    let createdAt: String
    let width, height: Int
    let color : String
    let altDescription: String?
    let urls: UrlsCodable
    let likedByUser: Bool
    let user: UserCodable
    let exif: Exif
    let views, downloads: Int

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color
        case altDescription = "alt_description"
        case urls
        case likedByUser = "liked_by_user"
        case user
        case exif
        case views, downloads
    }
}

// MARK: - Exif
struct Exif: Codable {
    let make, model, name, exposureTime: String
    let aperture, focalLength: String
    let iso: Int

    enum CodingKeys: String, CodingKey {
        case make, model, name
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
}

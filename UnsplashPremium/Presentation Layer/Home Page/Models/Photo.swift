//
//  Photo.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import Foundation

struct Photo {
    let id: String
    let urlStringSmall: String
    let urlStringLarge: String
    let userName: String
    let details: PhotoDetail
}

struct PhotoDetail {
    let color: String
    let created_at: String
    let name: String
    let blurHash: String
}

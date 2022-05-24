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
    let aspectRatio: Double
    let details: PhotoDetail
    
    init(wrapper: PhotoWrapper) {
        self.id = wrapper.id
        self.urlStringLarge = wrapper.urls.regular
        self.urlStringSmall = wrapper.urls.small
        self.userName = wrapper.user.name
        self.aspectRatio = Double(wrapper.width)/Double(wrapper.height)
        self.details = PhotoDetail(
            color: wrapper.color,
            created_at: wrapper.createdAt,
            name: wrapper.user.name,
            blurHash: wrapper.blurHash,
            likedByUser: wrapper.likedByUser
        )
    }
    init(wrapper: PhotoDetailedWrapper) {
        self.id = wrapper.id
        self.urlStringLarge = wrapper.urls.regular
        self.urlStringSmall = wrapper.urls.small
        self.userName = wrapper.user.name
        self.aspectRatio = Double(wrapper.width)/Double(wrapper.height)
        self.details = PhotoDetail(
            color: wrapper.color,
            created_at: wrapper.createdAt,
            name: wrapper.user.name,
            blurHash: nil,
            likedByUser: wrapper.likedByUser
        )
    }
}

struct PhotoDetail {
    let color: String
    let created_at: String
    let name: String
    let blurHash: String?
    let likedByUser: Bool
}

//
//  ProfileUpdatable.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import Foundation

struct ProfileUpdatable {
    let username: String
    let firstName: String
    let secondName: String
    let email: String
    let url: String?
    let location: String?
    
    init(profile: UserProfileUpdatableWrapper){
        self.username = profile.username
        self.firstName = profile.firstName
        self.secondName = profile.lastName
        self.email = profile.email
        self.url = profile.portfolioURL
        self.location = profile.location
    }
    init(username: String, firstName: String, secondName: String, email: String, url: String? = nil, location: String? = nil){
        self.username = username
        self.firstName = firstName
        self.secondName = secondName
        self.email = email
        self.url = url
        self.location = location
    }
}

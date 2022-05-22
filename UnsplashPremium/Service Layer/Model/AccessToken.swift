//
//  AccessToken.swift
//  UnsplashPremium
//
//  Created by user on 18.05.2022.
//

import Foundation

struct AccessToken: Codable {
    let access_token: String
    let refresh_token: String
    let scope: String
}

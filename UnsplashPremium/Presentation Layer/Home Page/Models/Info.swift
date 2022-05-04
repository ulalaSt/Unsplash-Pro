//
//  Info.swift
//  UnsplashPremium
//
//  Created by user on 04.05.2022.
//

import Foundation

struct Info {
    let key: InfoKeys
    var value: String
}

enum InfoKeys: String {
    case make = "Make"
    case focalLength = "Focal length"
    case model = "Model"
    case iso = "ISO"
    case shutterSpeed = "Shutter speed"
    case dimensions = "Dimensions"
    case aperture = "Aperture"
    case published = "Published"
}

//
//  UnsplashViewModel.swift
//  UnsplashPremium
//
//  Created by user on 13.05.2022.
//

import Foundation

class UnsplashViewModel {
    let tableCellData: [[TableCellData]] = [
        [
            TableCellData(configurator: UnsplashLogoCellConfigurator(item: "v2.6 (119)"), height: 120)
        ],
        [
            TableCellData(configurator: TextInfoCellConfigurator(item: "Reccommend Unsplash"), height: 40),
            TableCellData(configurator: TextInfoCellConfigurator(item: "Write a review"), height: 40),
            TableCellData(configurator: TextInfoCellConfigurator(item: "Send us feedback"), height: 40),
        ],
        [
            TableCellData(configurator: TextInfoCellConfigurator(item: "Visit unsplash.com"), height: 40),
            TableCellData(configurator: TextInfoCellConfigurator(item: "License"), height: 40)
        ]
    ]
}

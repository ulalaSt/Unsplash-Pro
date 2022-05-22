//
//  File.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import Foundation
import UIKit

class ResizableTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

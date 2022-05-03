//
//  Action.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit

enum CollectionAction: Hashable {
    case didSelect
    case didReachedEnd
    
    var hashValue: Int {
        switch self {
        case .didSelect: return 0
        case .didReachedEnd: return 1
        }
    }
}

struct CollectionActionEventData {
    let action: CollectionAction
    let cell: UIView
}

extension CollectionAction {
    static let notificationName = NSNotification.Name("collectionAction")
    
    func invoke(cell: UIView) {
        NotificationCenter.default.post(name: CollectionAction.notificationName, object: nil, userInfo: ["data": CollectionActionEventData(action: self, cell: cell)])
    }
}

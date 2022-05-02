//
//  ActionProxy.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import Foundation
import UIKit

class CollectionActionProxy {
    private var actions = [String: ((CellConfigurator,UIView) -> Void)]()
    
    func invoke(action: CollectionAction, cell: UIView, configurator: CellConfigurator) {
        let key = "\(action.hashValue)\(type(of: configurator).reuseId)"
        if let action = actions[key] {
            action(configurator, cell)
        }
    }

    func on<CellType, DataType>(action: CollectionAction, handler: @escaping ((CollectionCellConfigurator<CellType, DataType>, CellType) -> Void)) {
        let key = "\(action.hashValue)\(CellType.reuseIdentifier)"
        actions[key] = { c, cell in
            handler(c as! CollectionCellConfigurator<CellType, DataType>, cell as! CellType)
        }
    }
}

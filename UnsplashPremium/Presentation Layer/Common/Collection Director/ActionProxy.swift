//
//  ActionProxy.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import Foundation
import UIKit

class ActionProxy {
    
    private var actions = [String: ((CellConfigurator,UIView) -> Void)]()
    
    func invoke(action: Action, cell: UIView, configurator: CellConfigurator) {
        let key = "\(action.hashValue)\(type(of: configurator).reuseId)"
        if let action = actions[key] {
            action(configurator, cell)
        }
    }
    
    func on<CellType, DataType>(action: Action, handler: @escaping ((TableCellConfigurator<CellType, DataType>, CellType) -> Void)) {
        let key = "\(action.hashValue)\(CellType.reuseIdentifier)"
        actions[key] = { c, cell in
            handler(c as! TableCellConfigurator<CellType, DataType>, cell as! CellType)
        }
    }
    
    func on<CellType, DataType>(action: Action, handler: @escaping ((CollectionCellConfigurator<CellType, DataType>, CellType) -> Void)) {
        let key = "\(action.hashValue)\(CellType.reuseIdentifier)"
        actions[key] = { c, cell in
            handler(c as! CollectionCellConfigurator<CellType, DataType>, cell as! CellType)
        }
    }
}

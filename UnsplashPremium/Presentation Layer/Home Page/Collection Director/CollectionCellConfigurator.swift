//
//  CollectionCellConfigurator.swift
//  One-Lab-5
//
//  Created by user on 29.04.2022.
//

import UIKit

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    
    static var reuseId: String { return CellType.reuseIdentifier }
    
    static var cellClass: AnyClass { return CellType.self }
    
    var data: DataType
    
    init(data: DataType){
        self.data = data
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: data)
    }
}

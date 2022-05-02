//
//  UserPhotosTableDirector.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 30.04.2022.
//

import Foundation
import UIKit

class UserPhotosTableDirector : NSObject {
    let tableView: UITableView
    var items = [UserPhotoCellData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, items: [UserPhotoCellData]) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.items = items
    }
    
    func updateItems(newItems: [UserPhotoCellData]) {
        self.items = newItems
    }
}

extension UserPhotosTableDirector : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfig = UserPhotoCellConfigurator(item: self.items[indexPath.row])
        tableView.register(type(of: cellConfig).cellClass, forCellReuseIdentifier: type(of:cellConfig).reuseId)
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConfig).reuseId, for: indexPath)
        cellConfig.configure(cell: cell)
        return cell
    }
}

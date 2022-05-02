//
//  UserCollectionsTableDirector.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 02.05.2022.
//

import Foundation
import UIKit

class UserCollectionsTableDirector : NSObject {
    let tableView: UITableView
    var items = [UserCollectionCellData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, items: [UserCollectionCellData]) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.items = items
    }
    
    func updateItems(newItems: [UserCollectionCellData]) {
        self.items = newItems
    }
}

extension UserCollectionsTableDirector : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfig = UserCollectionCellConfigurator(item: self.items[indexPath.row])
        tableView.register(type(of: cellConfig).cellClass, forCellReuseIdentifier: type(of:cellConfig).reuseId)
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConfig).reuseId, for: indexPath)
        cellConfig.configure(cell: cell)
        return cell
    }
}

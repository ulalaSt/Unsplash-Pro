//
//  UserTableDirector.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import Foundation
import UIKit

class UsersTableDirector : NSObject {
    
    let tableView: UITableView
    var items = [UserCellData]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, items: [UserCellData]) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.items = items
    }
    
    func updateItems(newItems: [UserCellData]) {
        self.items = newItems
    }
}

extension UsersTableDirector : UITableViewDelegate, UITableViewDataSource {

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
        let cellConfig = UserCellConfigurator(item: self.items[indexPath.row])
        tableView.register(type(of: cellConfig).cellClass, forCellReuseIdentifier: type(of:cellConfig).reuseId)
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellConfig).reuseId, for: indexPath)
        cellConfig.configure(cell: cell)
        return cell
    }
}

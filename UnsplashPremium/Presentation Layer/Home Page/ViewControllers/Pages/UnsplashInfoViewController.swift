//
//  UnsplashInfoViewController.swift
//  UnsplashPremium
//
//  Created by user on 13.05.2022.
//

import UIKit
import SnapKit

class UnsplashInfoViewController: UIViewController {
    
    let viewModel = UnsplashViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.sectionHeaderHeight = 30
        return tableView
    }()
    
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView)
        return tableDirector
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        layout()
        setTableCells()
    }
    
    private func layout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func setTableCells(){
        tableDirector.updateItems(with: viewModel.tableCellData)
    }

}

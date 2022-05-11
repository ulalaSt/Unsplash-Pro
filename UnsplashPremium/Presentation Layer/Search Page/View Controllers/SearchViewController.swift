//
//  SearchViewController.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .white
        searchBar.tintColor = .white
        searchBar.sizeToFit()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        return searchBar
    }()
    
    private let viewModel: SearchRecommendationViewModel
        
    var resultViewController: ResultPageViewController!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView)
        return tableDirector
    }()
    
    init(viewModel: SearchRecommendationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func bindViewModel() {
        
        viewModel.didLoadDiscoveryPhotos = { photos in
            self.tableDirector.addItems(with: [
                TableCellData(configurator: TitleRecommendationCellConfigurator(item: "Browse by Category"),
                              height: 60),
                TableCellData(configurator: CategoryContainingCellConfigurator(item: self.viewModel.categories),
                              height: self.view.frame.width-60.0),
                TableCellData(configurator: TitleRecommendationCellConfigurator(item: "Discover"),
                              height: 60),
                TableCellData(configurator: CollectionContainingCellConfigurator(item: photos),
                              height: self.view.frame.size.height)
            ])
        }
    }
    private func fetchData() {
        viewModel.getDiscoveryPhotos()
    }
    private func setActionsForCells() {
        tableDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photoUrl = configurator.data.urlStringLarge
            let userName = configurator.data.userName
            let id = configurator.data.id
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(
                    photoUrlString: photoUrl,
                    userName: userName,
                    photoId: id
                ),
                animated: true
            )
        }
    }
}




extension SearchViewController: UISearchBarDelegate {
    //to search for headlines when is entered
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchBar.endEditing(true)
            self.tableView.isHidden = true
            resultViewController = ResultPageViewController(query: text)
            self.addChild(resultViewController)
            self.view.addSubview(resultViewController.view)
            resultViewController.view.snp.makeConstraints {
                $0.top.equalTo(self.searchBar.snp.bottom)
                $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    //to get topheadlines again when is canceled
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.isHidden = false
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        searchBar.text = nil
        searchBar.endEditing(true)
    }
}

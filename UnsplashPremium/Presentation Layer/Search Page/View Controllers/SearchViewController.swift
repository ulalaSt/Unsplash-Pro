//
//  SearchViewController.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout

class SearchViewController: UIViewController {
    
    private let viewModel: SearchRecommendationViewModel
        
    var resultViewController: ResultPageViewController?

    private var photos: [Photo]?

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
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.itemRenderDirection = .shortestFirst
        layout.minimumInteritemSpacing = 4.0
        layout.minimumColumnSpacing = 4.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private lazy var collectionDirector: WaterfallCollectionDirector = {
        let collectionDirector = WaterfallCollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView)
        return tableDirector
    }()
        
    private func fetchData(){
        viewModel.getDiscoveryPhotos()
        
    }
    private func fetchOtherData(){
        if let photos = photos {
            collectionDirector.updateItems(with:
                photos.map({
                CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: $0),
                                   size: Size(width: view.frame.width,
                                              height: view.frame.width/$0.aspectRatio))
                })
            )
        }
    }
    
    init(viewModel: SearchRecommendationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        collectionView.contentInset = UIEdgeInsets(top: self.view.frame.width+60.0, left: 0, bottom: 0, right: 0)
        collectionView.clipsToBounds = false
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(collectionView.snp.top)
            $0.height.equalTo(self.view.frame.width+60.0)
            $0.width.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        viewModel.didLoadDiscoveryPhotos = { photos in
            self.tableDirector.updateItems(with: [
                TableCellData(configurator: TitleRecommendationCellConfigurator(item: TitleCellData(text: "Browse by Category",
                                                                                                    textFont: .systemFont(
                                                                                                        ofSize: 35,
                                                                                                        weight: .semibold))),
                              height: 60),
                TableCellData(configurator: CategoryContainingCellConfigurator(item: self.viewModel.categories),
                              height: self.view.frame.width-60.0),
                TableCellData(configurator: TitleRecommendationCellConfigurator(item: TitleCellData(text: "Discover",
                                                                                                    textFont: .systemFont(
                                                                                                        ofSize: 35,
                                                                                                        weight: .semibold))),
                              height: 60)
            ])
            self.photos = photos
            self.fetchOtherData()
        }
    }
    
    private func setActionsForCells() {
        tableDirector.actionProxy.on(action: .custom("categorySelected")) { [weak self] (configurator: CategoryContainingCellConfigurator, cell) in
            guard let configurator = cell.tappedSearchedCollectionCellConfigurator else {
                return
            }
            let title = configurator.data.title
            let photosPage = PhotoResultPage(with: PhotoResultViewModel(resultsService: SearchResultServiceImplementation()),
                                             query: title)
            photosPage.title = title
            self?.navigationController?.pushViewController(
                photosPage,
                animated: true
            )
        }
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
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
    
    private func showResultView(){
        self.tableView.isHidden = true
        self.collectionView.isHidden = true
        
        if let resultViewController = resultViewController {
            self.addChild(resultViewController)
            self.view.addSubview(resultViewController.view)
            resultViewController.view.snp.makeConstraints {
                $0.edges.equalTo(self.view.safeAreaLayoutGuide)
            }
            resultViewController.didMove(toParent: self)
        }
    }
    private func removeResultView(){
        self.tableView.isHidden = false
        self.collectionView.isHidden = false
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        self.resultViewController = nil
    }
}




extension SearchViewController: UISearchBarDelegate {
    
    //to search for headlines when is entered
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchBar.endEditing(true)
            resultViewController = ResultPageViewController(query: text)
            showResultView()
        }
    }
    
    
    //to get topheadlines again when is canceled
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        removeResultView()
    }
}

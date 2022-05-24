//
//  PhotoResultPage.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import UIKit
import SnapKit

class UserResultPage: UIViewController {
    
    private let viewModel: UserResultViewModel
    
    private var currentLastPage = 1
    
    private var query: String
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy private var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    private let noDataLabel: UILabel = {
        let noDataLabel = UILabel()
        noDataLabel.font = .systemFont(ofSize: 25, weight: .bold)
        noDataLabel.textColor = .white
        noDataLabel.textAlignment = .center
        noDataLabel.text = "No results"
        return noDataLabel
    }()
    
    init(with viewModel: UserResultViewModel, query: String){
        self.viewModel = viewModel
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: ColorKeys.background)
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func layoutNoDataInfo() {
        view.addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }

    private func bindViewModel(){
        viewModel.didLoadSearchedUsers = { [weak self] users in
            guard let strongSelf = self else {
                return
            }
            
            if users.isEmpty {
                strongSelf.layoutNoDataInfo()
            } else {
                strongSelf.collectionDirector.updateItems(with: users.map { user in
                    CollectionCellData(cellConfigurator: SearchedUserCellConfigurator(data: user),
                                       size: Size(width: strongSelf.view.frame.width,
                                                  height: 80))
                })
            }
        }
        viewModel.didLoadAdditionalSearchedUsers = { [weak self] users in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionDirector.addItems(with: users.map { user in
                CollectionCellData(cellConfigurator: SearchedUserCellConfigurator(data: user),
                                   size: Size(width: strongSelf.view.frame.width,
                                              height: 80))
            })
        }
    }
    
    // request from service
    func fetchData() {
        viewModel.getSearchedUsers(for: query, page: currentLastPage)
    }
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self](configurator: SearchedUserCellConfigurator, cell) in
            let user = configurator.data
            self?.navigationController?.pushViewController(
                UserDetailViewController(
                    viewModel: UserDetailViewModel(resultsService: UserDetailServiceImplementation()),
                    user: user
                ),
                animated: true)
            
        }
    }
}

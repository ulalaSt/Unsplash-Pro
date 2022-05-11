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
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    lazy private var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
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
    
    private func bindViewModel(){
        viewModel.didLoadSearchedUsers = { [weak self] users in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionDirector.updateItems(with: users.map { user in
                CollectionCellData(cellConfigurator: SearchedUserCellConfigurator(data: user),
                                   size: Size(width: strongSelf.view.frame.width,
                                              height: 80))
            })
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
//        collectionDirector.actionProxy.on(action: .didReachedEnd) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.currentLastPage = strongSelf.currentLastPage + 1
//            strongSelf.fetchData()
//        }
    }
}

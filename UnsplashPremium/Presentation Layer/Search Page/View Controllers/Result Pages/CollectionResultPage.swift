//
//  PhotoResultPage.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import UIKit
import SnapKit

class CollectionResultPage: UIViewController {

    private let viewModel: CollectionResultViewModel
    
    private var currentLastPage = 1
    
    private var query: String

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    lazy private var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    lazy private var noResultStackView: UIStackView = {
        let noResultStackView = UIStackView()
        noResultStackView.axis = .vertical
        noResultStackView.addArrangedSubview(noDataIcon)
        noResultStackView.addArrangedSubview(noPhotoLabel)
        return noResultStackView
    }()
    
    private let noDataIcon: UIImageView = {
        let image = UIImage(named: "noDataIcon")
        let noDataIcon = UIImageView(image: image)
        noDataIcon.contentMode = .scaleAspectFit
        return noDataIcon
    }()
    
    private let noPhotoLabel: UILabel = {
        let noPhotoLabel = UILabel()
        noPhotoLabel.font = .systemFont(ofSize: 17, weight: .bold)
        noPhotoLabel.textColor = .darkGray
        noPhotoLabel.textAlignment = .center
        noPhotoLabel.text = "No collections"
        return noPhotoLabel
    }()
    

    init(with viewModel: CollectionResultViewModel, query: String){
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
    
    private func layoutNoDataInfo() {
        noDataIcon.snp.makeConstraints{
            $0.size.equalTo(150)
        }
        view.addSubview(noResultStackView)
        noResultStackView.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }

    private func bindViewModel(){
        viewModel.didLoadSearchedCollections = { [weak self] collections in
            guard let strongSelf = self else {
                return
            }
            if collections.isEmpty {
                strongSelf.layoutNoDataInfo()
            } else {
                strongSelf.collectionDirector.updateItems(with: collections.map { collection in
                    CollectionCellData(cellConfigurator: SearchedCollectionCellConfigurator(data: collection),
                                       size: Size(width: strongSelf.view.frame.width,
                                                  height: 250))
                })
            }
        }
        viewModel.didLoadAdditionalSearchedCollections = { [weak self] collections in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionDirector.addItems(with: collections.map { collection in
                CollectionCellData(cellConfigurator: SearchedCollectionCellConfigurator(data: collection),
                                   size: Size(width: strongSelf.view.frame.width,
                                              height: 250))
            })
        }
    }
    
    private func fetchData(){
        viewModel.getSearchedCollections(for: query, page: currentLastPage)
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
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: SearchedCollectionCellConfigurator, cell) in
            let collectionDetail =
            CollectionDetailViewController(
                viewModel: CollectionDetailViewModel(resultsService: CollectionDetailServiceImplementation()),
                title: configurator.data.title,
                id: configurator.data.id)
            self?.navigationController?.pushViewController(collectionDetail,
                                                           animated: true)
        }

    }
}

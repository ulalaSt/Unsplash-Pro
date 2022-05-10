//
//  SearchViewController.swift
//  UnsplashPremium
//
//  Created by user on 07.05.2022.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModel
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
    }
    
    private func bindViewModel(){
        viewModel.didLoadCategoryPhotos = { categories in
            self.collectionDirector.updateItemSizes(with: [
                Size(width: self.collectionView.frame.width, height: 60),
                Size(width: self.collectionView.frame.width, height: self.collectionView.frame.width),
                Size(width: self.collectionView.frame.width, height: 60)
            ])
            
            self.collectionDirector.updateItems(with: [
                SearchPageTitleCellConfigurator(data: "Browse by Category"),
                CategoriesCellConfigurator(data: categories),
                SearchPageTitleCellConfigurator(data: "Discover"),
            ])
            
        }
        
        viewModel.didLoadRandomPhoto = { photo in
            self.collectionDirector.addItemSizes(with: [Size(width: (self.view.frame.width-1.0)/2.0,
                                                             height: (self.view.frame.width-1.0)/2.0/photo.aspectRatio)])
            self.collectionDirector.addItems(with: [SearchPagePhotoCellConfigurator(data: photo)])
        }
    }
    
    private func fetchData(){
        DispatchQueue.global().async {
            self.viewModel.getCategories()
            self.viewModel.getRandomPhotos(of: 10)
        }
        
    }
    
    private func setActionsForCells(){
        
    }
}

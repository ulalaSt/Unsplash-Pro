//
//  ViewController.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit
import SnapKit

class EditorialPage: UIViewController {
    
    private let viewModel: HomeViewModel
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadCollection), for: .valueChanged)
        refreshControl.tintColor = .white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading Data...", attributes: attributes)
        refreshControl.layer.zPosition = -1
        return refreshControl
    }()
    
    @objc private func reloadCollection(){
        self.collectionView.refreshControl?.beginRefreshing()
        self.fetchData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        collectionView.refreshControl = self.refreshControl
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }

    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func bindViewModel(){
        viewModel.didLoadEditorialPhotos = { [weak self] photos in
            self?.collectionDirector.updateItems(with: photos.map({ photo in
                HomePhotoConfigurator(
                    data: Photo(
                        id: photo.id,
                        urlStringSmall: photo.urls.small,
                        urlStringLarge: photo.urls.regular,
                        userName: photo.user.name,
                        details: PhotoDetail(
                            size: Size(
                                width: photo.width,
                                height: photo.height),
                            color: photo.color,
                            created_at: photo.createdAt,
                            name: photo.user.name)))
            }))
        }
    }
    private func setActionsForCells() {
        self.collectionDirector.actionProxy.on(action: .didSelect) { (configurator: HomePhotoConfigurator, cell) in
            let data = configurator.data
            self.navigationController?.pushViewController(DetailPage(viewModel: data), animated: true)
        }
    }

    private func fetchData() {
        viewModel.getEditorialPhotos()
    }
}

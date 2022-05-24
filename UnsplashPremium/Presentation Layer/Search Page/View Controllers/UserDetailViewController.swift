//
//  UserDetailViewController.swift
//  UnsplashPremium
//
//  Created by user on 12.05.2022.
//

import UIKit
import SnapKit

class UserDetailViewController: UIViewController {
    
    private let viewModel: UserDetailViewModel
    
    private var currentLastPage = 1
    
    private let user: UserWrapper
    
    private var userPhotos: [Photo]? {
        didSet {
            if segmentedControl.selectedSegmentIndex == 0 {
                collectionView.reloadData()
            }
        }
    }
    private var userLikes: [Photo]? {
        didSet {
            if segmentedControl.selectedSegmentIndex == 1 {
                collectionView.reloadData()
            }
        }
    }
    private var userCollections: [Collection]? {
        didSet {
            if segmentedControl.selectedSegmentIndex == 2 {
                collectionView.reloadData()
            }
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Photos", "Likes", "Collections"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.selectedSegmentTintColor = .lightGray
        segmentedControl.tintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.isUserInteractionEnabled = true
        segmentedControl.addTarget(self, action: #selector(segmentAction(segmentedControl:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy private var noResultStackView: UIStackView = {
        let noResultStackView = UIStackView()
        noResultStackView.axis = .vertical
        noResultStackView.isHidden = true
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
        return noPhotoLabel
    }()
    
    @objc private func segmentAction(segmentedControl: UISegmentedControl){
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            guard let userPhotos = userPhotos else {
                return
            }
            if userPhotos.isEmpty {
                noPhotoLabel.text = "No photos"
                noResultStackView.isHidden = false
                collectionView.isHidden = true
                collectionDirector.updateItems(with: [])
            } else {
                collectionView.isHidden = false
                noResultStackView.isHidden = true
                collectionDirector.updateItems(with: userPhotos.map({
                    CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: $0),
                                       size: Size(width: self.view.frame.width, height: self.view.frame.width/$0.aspectRatio))
                }))
            }
        } else if selectedIndex == 1 {
            guard let userLikes = userLikes else {
                return
            }
            if userLikes.isEmpty {
                noPhotoLabel.text = "No likes"
                noResultStackView.isHidden = false
                collectionDirector.updateItems(with: [])
            } else {
                noResultStackView.isHidden = true
                collectionDirector.updateItems(with: userLikes.map({
                    CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: $0),
                                       size: Size(width: self.view.frame.width, height: self.view.frame.width/$0.aspectRatio))
                }))
            }
        } else {
            guard let userCollections = userCollections else {
                return
            }
            if userCollections.isEmpty {
                noPhotoLabel.text = "No collections"
                noResultStackView.isHidden = false
                collectionDirector.updateItems(with: [])
            } else {
                noResultStackView.isHidden = true
                collectionDirector.updateItems(with: userCollections.map({
                    CollectionCellData(cellConfigurator: SearchedCollectionCellConfigurator(data: $0),
                                       size: nil)
                }))
            }
        }
    }
    
    private let userDetailTopView: UserDetailTopView = {
        let userDetailTopView = UserDetailTopView()
        userDetailTopView.backgroundColor = .init(white: 0.1, alpha: 1)
        return userDetailTopView
    }()
        
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    // initialize with specific topic
    init(viewModel: UserDetailViewModel, user: UserWrapper) {
        self.viewModel = viewModel
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: ColorKeys.background)
        segmentedControl.selectedSegmentIndex = 0
        userDetailTopView.configure(with: user)
        layout()
        layoutNoDataInfo()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionView.contentInset = UIEdgeInsets(top: view.frame.height/2+40, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints{
            $0.bottom.equalTo(collectionView.snp.top).offset(-20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(view).inset(20)
            $0.height.equalTo(40)
        }
        collectionView.addSubview(userDetailTopView)
        userDetailTopView.snp.makeConstraints {
            $0.bottom.equalTo(segmentedControl.snp.top).offset(-20)
            $0.width.equalTo(view)
            $0.height.equalTo(view).dividedBy(2)
        }
    }
    
    private func layoutNoDataInfo() {
        noDataIcon.snp.makeConstraints{
            $0.size.equalTo(150)
        }
        view.addSubview(noResultStackView)
        noResultStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(segmentedControl.snp.bottom).offset(50)
        }
    }
    
    // to reload collectionView with topic related images
    private func bindViewModel(){
        viewModel.didLoadUserPhotos = {
            self.userPhotos = $0
            self.collectionDirector.updateItems(with: $0.map({ photo in
                CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: photo),
                                   size: Size(width: self.view.frame.width, height: self.view.frame.width/photo.aspectRatio))
            }))
        }
        viewModel.didLoadAdditionalUserPhotos = { self.userPhotos?.append(contentsOf: $0) }
        
        viewModel.didLoadUserLikes = { self.userLikes = $0 }
        viewModel.didLoadAdditionalUserLikes = { self.userLikes?.append(contentsOf: $0) }
        
        viewModel.didLoadUserCollections = { self.userCollections = $0 }
        viewModel.didLoadAdditionalUserCollections = { self.userCollections?.append(contentsOf: $0) }
    }
    
    // initial request from service
    private func fetchData() {
        viewModel.getUserPhotos(username: user.username, page: 1)
        viewModel.getUserLikes(username: user.username, page: 1)
        viewModel.getUserCollections(username: user.username, page: 1)
    }
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photo = configurator.data
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(photo: photo),
                animated: true
            )
        }
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: SearchedCollectionCellConfigurator, cell) in
            self?.navigationController?.pushViewController(
                CollectionDetailViewController(
                    viewModel: CollectionDetailViewModel(resultsService: CollectionDetailServiceImplementation()),
                    title: configurator.data.title,
                    id: configurator.data.id),
                animated: true)
        }

    }

}

//
//  ProfileViewController.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit
import SnapKit
import AuthenticationServices

class ProfileViewController: UIViewController {
        
    private let viewModel: ProfileViewModel
    
    private var userProfile: UserProfileWrapper?
    
    init(viewModel: ProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentLastPage = 1
        
    private var userPhotos: [Photo]?
    private var userLikes: [Photo]?
    private var userCollections: [Collection]?
    
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
        segmentedControl.selectedSegmentIndex = 0
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
    private let shareIcon: UIButton = {
        let shareIcon = UIButton()
        shareIcon.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareIcon.tintColor = .white
        return shareIcon
    }()
    private let ellipsisDotsIcon: UIButton = {
        let ellipsisDotsIcon = UIButton()
        ellipsisDotsIcon.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        ellipsisDotsIcon.tintColor = .white
        ellipsisDotsIcon.addTarget(self, action: #selector(didTapEllipsisDots), for: .touchUpInside)
        return ellipsisDotsIcon
    }()
    
    @objc private func didTapEllipsisDots(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let accountSettings = UIAlertAction(title: "Account Settings", style: .default) { [weak self] _ in
            guard let userProfile = self?.userProfile else {
                return
            }
            let accountViewController =  AccountSettingsViewController(profile: userProfile)
            let navigationController = UINavigationController(rootViewController: accountViewController)
            
            self?.present(navigationController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logout = UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            UserDefaults.standard.removeObject(forKey: DefaultKeys.currentUserAccessTokenKey)
            UserDefaults.standard.removeObject(forKey: DefaultKeys.currentUserAccessScopeKey)
            self?.view.removeFromSuperview()
            self?.removeFromParent()
        }
        alert.addAction(accountSettings)
        alert.addAction(cancel)
        alert.addAction(logout)
        present(alert, animated: true, completion: nil)
    }

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
    
    private let userDetailTopView: ProfileTopView = {
        let userDetailTopView = ProfileTopView()
        userDetailTopView.backgroundColor = .init(white: 0.1, alpha: 1)
        return userDetailTopView
    }()
        
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
            $0.height.equalTo(view).dividedBy(3)
        }
        userDetailTopView.addSubview(shareIcon)
        shareIcon.snp.makeConstraints{
            $0.top.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(40)
        }
        userDetailTopView.addSubview(ellipsisDotsIcon)
        ellipsisDotsIcon.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalTo(shareIcon.snp.leading).offset(-30)
            $0.size.equalTo(40)
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
        viewModel.didLoadUserProfile = { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userProfile = profile
                UserDefaults.standard.set(profile.firstName, forKey: DefaultKeys.userFirstName)
                    self?.userDetailTopView.configure(userName: profile.name, imageURL: profile.profileImage.medium)
                    self?.viewModel.getUserPhotos(username: profile.username, page: 1)
                    self?.viewModel.getUserLikes(username: profile.username, page: 1)
                    self?.viewModel.getUserCollections(username: profile.username, page: 1)
            case .failure(let error):
                print("Error: \(error)")
            }
        }

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
        viewModel.getUserProfile()
    }
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(
                    photoUrlString: configurator.data.urlStringLarge,
                    userName: configurator.data.userName,
                    photoId: configurator.data.id),
                animated: true)
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
    
    func presentWelcomePage(){
        var firstName = "User"
        if let name = UserDefaults.standard.string(forKey: DefaultKeys.userFirstName) {
            firstName = name
        }
        let viewController = WelcomeViewController(name: firstName)
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        present(viewController, animated: true, completion: nil)
    }
}

extension ProfileViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
}

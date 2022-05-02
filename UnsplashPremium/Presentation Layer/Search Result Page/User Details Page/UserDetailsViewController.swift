//
//  UserDetailsViewController.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 28.04.2022.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    private let viewModel = UserDetailsViewModel(usersService: UsersServiceImplementation())
    var userCellData: UserCellData? = nil
    
    let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return userNameLabel
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Photos", "Likes", "Collections"])
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentTintColor = .lightGray
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        return segmentedControl
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .init(white: 0, alpha: 0)
        return containerView
    }()
    let photosView: UITableView = {
        let photosView = UITableView()
        photosView.backgroundColor = .init(white: 0, alpha: 0)
        photosView.isHidden = false
        return photosView
    }()
    
    private lazy var photosTableDirector: UserPhotosTableDirector = {
        let tableDirector = UserPhotosTableDirector(tableView: photosView, items: [])
        return tableDirector
    }()
    
    let likesView: UITableView = {
        let likesView = UITableView()
        likesView.backgroundColor = .init(white: 0, alpha: 0)
        likesView.isHidden = true
        return likesView
    }()
    
    private lazy var likesTableDirector: UserLikesTableDirector = {
        let tableDirector = UserLikesTableDirector(tableView: likesView, items: [])
        return tableDirector
    }()
    
    let collectionsView: UITableView = {
        let collectionsView = UITableView()
        collectionsView.backgroundColor = .init(white: 0, alpha: 0)
        collectionsView.isHidden = true
        return collectionsView
    }()
    
    private lazy var collectionsTableDirector: UserCollectionsTableDirector = {
        let tableDirector = UserCollectionsTableDirector(tableView: collectionsView, items: [])
        return tableDirector
    }()

    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .lightGray
        return locationLabel
    }()
    
    let locationIcon: UIImageView = {
        let locationIcon = UIImageView()
        locationIcon.image = UIImage(systemName: "location.circle.fill")
        locationIcon.tintColor = .lightGray
        return locationIcon
    }()
    
    let websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.textColor = .lightGray
        websiteLabel.numberOfLines = 2
        return websiteLabel
    }()
    
    let websiteIcon: UIImageView = {
        let websiteIcon = UIImageView()
        websiteIcon.image = UIImage(systemName: "network")
        websiteIcon.tintColor = .lightGray
        return websiteIcon
    }()
    
    lazy var locationStackView: UIStackView = {
        let locationStackView = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        locationStackView.spacing = 15
        locationStackView.axis = .horizontal
        return locationStackView
    }()
    
    lazy var websiteStackView: UIStackView = {
        let websiteStackView = UIStackView(arrangedSubviews: [websiteIcon, websiteLabel])
        websiteStackView.spacing = 15
        websiteStackView.axis = .horizontal
        return websiteStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureNavigationBar()
        configureProfileImage()
        configureUserName()
        configureLocationView()
        configureWebsiteView()
        configureSegmentedControl()
        configureContainer()
        configurePhotosView()
        configureLikesView()
        configureCollectionsView()
        loadPhotos()
        loadLikes()
        loadCollections()
        loadProfile()
    }
    
    private func configureNavigationBar() {
        let leftNavigationItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backToSearchResult))
        leftNavigationItem.tintColor = .systemGray
        navigationItem.leftBarButtonItem = leftNavigationItem
    }
    
    private func configureProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(60)
        }
        
        PhotosServiceImplementation.getImage(urlString: userCellData?.profileImageUrl ?? "") {[weak self] result in
            switch result {
            case .success(let image):
                self?.profileImageView.image = image
                self?.profileImageView.layer.cornerRadius = (self?.profileImageView.bounds.width)! / 2
                self?.profileImageView.clipsToBounds = true
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
    
    private func configureUserName() {
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        userNameLabel.text = userCellData?.name ?? ""
    }
    
    private func configureLocationView() {
        view.addSubview(locationStackView)
        locationIcon.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
    }
    
    private func configureWebsiteView() {
        view.addSubview(websiteStackView)
        
        websiteIcon.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        websiteLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        websiteStackView.snp.makeConstraints {
            $0.top.equalTo(locationStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(websiteStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func configureContainer() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func configurePhotosView() {
        containerView.addSubview(photosView)
        photosView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureLikesView() {
        containerView.addSubview(likesView)
        likesView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionsView() {
        containerView.addSubview(collectionsView)
        collectionsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func backToSearchResult() {
        dismiss(animated: true)
    }

    @objc private func changeSegment(sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
              case 0:
                photosView.isHidden = false
                likesView.isHidden = true
                collectionsView.isHidden = true
              case 1:
                photosView.isHidden = true
                likesView.isHidden = false
                collectionsView.isHidden = true
              default:
                photosView.isHidden = true
                likesView.isHidden = true
                collectionsView.isHidden = false
          }
    }
    
    private func bindViewModel() {
        viewModel.didLoadUserPhotos = { [weak self] photos in
            self?.photosTableDirector.updateItems(newItems: photos.map({ photo in
                UserPhotoCellData(url: photo.urls.regular)
            }))
        }
        viewModel.didLoadUserLikes = { [weak self] photos in
            self?.likesTableDirector.updateItems(newItems: photos.map({ photo in
                UserLikeCellData(url: photo.urls.regular, username: photo.user.name)
            }))
        }
        viewModel.didLoadUserCollections = { [weak self] collections in
            self?.collectionsTableDirector.updateItems(newItems: collections.map({ collection in
                UserCollectionCellData(url: collection.coverPhoto.urls.regular, title: collection.title)
            }))
        }
        viewModel.didLoadUserProfile = { [weak self] user in
            if user.website == nil {
                self?.websiteStackView.isHidden = true
            } else {
                self?.websiteLabel.text = user.website
            }
            
            if user.location == nil {
                self?.locationStackView.isHidden = true
            } else {
                self?.locationLabel.text = user.location
            }
        }

    }

    private func loadPhotos() {
        viewModel.getUserPhotos(username: userCellData?.nickname ?? "")
    }
    
    private func loadLikes() {
        viewModel.getUserLikes(username: userCellData?.nickname ?? "")
    }
    
    private func loadCollections() {
        viewModel.getUserCollections(username: userCellData?.nickname ?? "")
    }
    
    private func loadProfile() {
        viewModel.getUserProfile(username: userCellData?.nickname ?? "")
    }
}

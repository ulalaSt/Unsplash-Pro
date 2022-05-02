//
//  SearchResultViewController.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import UIKit

class SearchResultViewController: UIViewController {

    private let viewModel = SearchResultViewModel(usersService: UsersServiceImplementation())
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Photos", "Collections", "Users"])
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        return segmentedControl
    }()
    let containerView = UIView()
    let photosView = UIView()
    let collectionsView = UIView()
    
    let usersView: UITableView = {
        let usersView = UITableView()
        usersView.separatorColor = .lightGray
        return usersView
    }()
    
    private lazy var usersTableDirector: UsersTableDirector = {
        let tableDirector = UsersTableDirector(tableView: usersView, items: [], cellSelectedListener: self)
        return tableDirector
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        bindViewModel()
        configureSegmentedControl()
        configureContainer()
        configurePhotosView()
        configureCollectionsView()
        configureUsersView()
    }

    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureContainer() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func configurePhotosView() {
        containerView.addSubview(photosView)
        photosView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        photosView.backgroundColor = .red
    }
    
    private func configureCollectionsView() {
        containerView.addSubview(collectionsView)
        collectionsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionsView.backgroundColor = .systemBlue
        collectionsView.isHidden = true
    }
    
    private func configureUsersView() {
        containerView.addSubview(usersView)
        usersView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        usersView.isHidden = true
    }
    
    @objc private func changeSegment(sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
              case 0:
                  photosView.isHidden = false
                  collectionsView.isHidden = true
                  usersView.isHidden = true
              case 1:
                  photosView.isHidden = true
                  collectionsView.isHidden = false
                  usersView.isHidden = true
              default:
                  photosView.isHidden = true
                  collectionsView.isHidden = true
                  usersView.isHidden = false
                  loadUsers()
          }
    }
    
    private func bindViewModel() {
        viewModel.didLoadUsers = { [weak self] usersWrapper in
            self?.usersTableDirector.updateItems(newItems: usersWrapper.results.map({ user in
                UserCellData(name: user.name, nickname: user.username, profileImageUrl: user.profileImageUrl.mediumImageUrl)
            }))
        }
    }

    private func loadUsers() {
        viewModel.searchUsers(query: "bob")
    }
}

extension SearchResultViewController : UserCellSelectedListener {
    func onUserCellSelected(userCellData: UserCellData) {
        let rootVC = UserDetailsViewController()
        rootVC.userCellData = userCellData
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.modalPresentationStyle = .currentContext
        present(navigationVC, animated: false)
    }
}

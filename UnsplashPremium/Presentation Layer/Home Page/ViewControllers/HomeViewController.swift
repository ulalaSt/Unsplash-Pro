//
//  ViewController.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let topicBar: TopicBar = {
        let topicBar = TopicBar()
        return topicBar
    }()
    
    private let viewModel: HomeViewModel
    
    private let unsplashView: UIImageView = {
        let unsplashView = UIImageView()
        let tintedImage = UIImage(named: "unsplash")?.withRenderingMode(.alwaysTemplate)
        unsplashView.image = tintedImage
        unsplashView.contentMode = .scaleAspectFit
        return unsplashView
    }()
    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")
        return logoView
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layout()
        setUpMenuBar()
        bindViewModel()
        fetchData()
    }

    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.navigationItem.titleView = unsplashView
        navigationItem.titleView?.tintColor = .white
        unsplashView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
    private func setUpMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        view.addSubview(topicBar)
        topicBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
    private func bindViewModel(){
        viewModel.didLoadEditorialPhotos = { [weak self] photos in
            self?.collectionDirector.updateItems(with: photos.map({ photo in
                Photo(id: photo.id, urlStringSmall: photo.urls.small, userName: photo.user.name)
            }))
        }
        viewModel.didLoadTopics = { [weak self] topics in
            print("updating")
            self?.topicBar.updateTopics(with: topics.map({
                Topic(id: $0.id, title: $0.title)
            }))
        }
    }
    private func fetchData() {
        viewModel.getEditorialPhotos()
        viewModel.getAllTopics()
    }

}


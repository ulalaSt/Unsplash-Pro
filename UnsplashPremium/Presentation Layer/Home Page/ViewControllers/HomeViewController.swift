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
        unsplashView.image = UIImage(named: "unsplash")?.withRenderingMode(.alwaysTemplate)
        unsplashView.contentMode = .scaleAspectFit
        return unsplashView
    }()
    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.contentMode = .scaleAspectFit
        logoView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysTemplate)
        logoView.tintColor = .white
        return logoView
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    private let gradientView: GradientView = {
        let gradientView = GradientView(gradientColor: .black)
        return gradientView
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
        self.navigationItem.titleView = unsplashView
        navigationItem.titleView?.tintColor = .white
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
        view.addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(65)
        }
        unsplashView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        view.addSubview(logoView)
        logoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
            $0.size.equalTo(20)
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


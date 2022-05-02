//
//  PhotoDetailViewController.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import UIKit
import SnapKit

class DetailPage: UIViewController {
    
    let viewModel: Photo
    
    let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.contentMode = .scaleAspectFit
        return photoView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let likeView: UIView = {
        let likeView = UIView()
        likeView.clipsToBounds = true
        likeView.backgroundColor = .darkGray
        return likeView
    }()
    let likeImageView: UIImageView = {
        let likeImageView = UIImageView(image: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate))
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.tintColor = UIColor.white
        return likeImageView
    }()
    let plusView: UIView = {
        let plusView = UIView()
        plusView.clipsToBounds = true
        plusView.backgroundColor = .darkGray
        return plusView
    }()
    let plusImageView: UIImageView = {
        let plusImageView = UIImageView(image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate))
        plusImageView.contentMode = .scaleAspectFit
        plusImageView.tintColor = UIColor.white
        return plusImageView
    }()
    let downloadView: UIView = {
        let downloadView = UIView()
        downloadView.clipsToBounds = true
        downloadView.backgroundColor = .white
        return downloadView
    }()
    let downloadImageView: UIImageView = {
        let downloadImageView = UIImageView(image: UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate))
        downloadImageView.contentMode = .scaleAspectFit
        downloadImageView.tintColor = UIColor.darkGray
        return downloadImageView
    }()
    let infoImageView: UIImageView = {
        let infoImageView = UIImageView(image: UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate))
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.tintColor = UIColor.white
        return infoImageView
    }()
    init(viewModel: Photo){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.titleView = titleLabel
        fetchData()
        layout()
    }
    private func fetchData(){
        PhotosServiceImplementation.getImage(urlString: viewModel.urlStringLarge) { [weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
        titleLabel.text = viewModel.userName
    }
    private func layout(){
        view.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        layoutIcons()
    }
    private func layoutIcons(){
        
        
        view.addSubview(downloadView)
        downloadView.layer.cornerRadius = 25
        downloadView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(100)
            $0.size.equalTo(50)
        }
        downloadView.addSubview(downloadImageView)
        downloadImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        
        view.addSubview(plusView)
        plusView.layer.cornerRadius = downloadView.layer.cornerRadius
        plusView.snp.makeConstraints {
            $0.trailing.equalTo(downloadView)
            $0.bottom.equalTo(downloadView.snp.top).offset(-10)
            $0.size.equalTo(downloadView)
        }
        plusView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        
        view.addSubview(likeView)
        likeView.layer.cornerRadius = downloadView.layer.cornerRadius
        likeView.snp.makeConstraints {
            $0.trailing.equalTo(downloadView)
            $0.bottom.equalTo(plusView.snp.top).offset(-10)
            $0.size.equalTo(downloadView)
        }
        likeView.addSubview(likeImageView)
        likeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        view.addSubview(infoImageView)
        infoImageView.snp.makeConstraints {
            $0.bottom.equalTo(downloadView)
            $0.leading.equalToSuperview().inset(10)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}

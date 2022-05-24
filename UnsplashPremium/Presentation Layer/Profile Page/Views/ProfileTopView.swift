//
//  UserDetailTopView.swift
//  UnsplashPremium
//
//  Created by user on 12.05.2022.
//

import Foundation
import UIKit
import SnapKit

class ProfileTopView: UIView {
    private let backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .darkGray
        return backView
    }()
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 30
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()

    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        usernameLabel.textColor = .white
        return usernameLabel
    }()
            
    private func layout(){
        addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview().priority(999)
            $0.size.equalTo(60)
        }
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(photoView)
            $0.top.equalTo(photoView.snp.bottom).offset(15)
        }
    }
    func configure(userName: String, imageURL: String) {
        DispatchQueue.main.async {
            self.usernameLabel.text = userName
            self.setUpImage(with: imageURL)
        }
        layout()
    }
    
    private func setUpImage(with urlString: String) {
        PhotosServiceImplementation.getImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }

}

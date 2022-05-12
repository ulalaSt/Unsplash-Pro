//
//  UserDetailTopView.swift
//  UnsplashPremium
//
//  Created by user on 12.05.2022.
//

import Foundation
import UIKit

class UserDetailTopView: UIView {
    private let backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .darkGray
        return backView
    }()
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 45
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()

    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        usernameLabel.textColor = .white
        return usernameLabel
    }()
    
    private let thirdIcon: UIImageView = {
        let thirdIcon = UIImageView()
        thirdIcon.tintColor = .lightGray
        return thirdIcon
    }()
    
    private let thirdLabel: UILabel = {
        let thirdLabel = UILabel()
        thirdLabel.font = .systemFont(ofSize: 17, weight: .regular)
        thirdLabel.textColor = .lightGray
        return thirdLabel
    }()

    private let fourthIcon: UIImageView = {
        let fourthIcon = UIImageView()
        fourthIcon.tintColor = .lightGray
        return fourthIcon
    }()
    
    private let fourthLabel: UILabel = {
        let fourthLabel = UILabel()
        fourthLabel.font = .systemFont(ofSize: 17, weight: .regular)
        fourthLabel.textColor = .lightGray
        return fourthLabel
    }()
        
    private func manageLayouts(user: UserWrapper){
        layoutMain()
        let hasLocation = user.location != nil
        let hasWebsite = user.website != nil
        
        if !hasLocation && !hasWebsite {
            return
        }
        else {
            layoutThirdIcon()

            if hasLocation {
                thirdIcon.image = UIImage(systemName: "location.circle.fill")
                thirdLabel.text = user.location
                if hasWebsite {
                    fourthIcon.image = UIImage(systemName: "network")
                    fourthLabel.text = user.website
                    layoutFourthIcon()
                }
            } else {
                thirdIcon.image = UIImage(systemName: "network")
                thirdLabel.text = user.website
            }
        }
    }
    private func layoutMain(){
        addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(90)
        }
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(photoView)
            $0.top.equalTo(photoView.snp.bottom).offset(15)
        }
    }
    private func layoutThirdIcon(){
        addSubview(thirdIcon)
        thirdIcon.snp.makeConstraints {
            $0.leading.equalTo(photoView)
            $0.top.equalTo(usernameLabel.snp.bottom).offset(10)
            $0.size.equalTo(20)
        }
        addSubview(thirdLabel)
        thirdLabel.snp.makeConstraints {
            $0.leading.equalTo(thirdIcon.snp.trailing).offset(10)
            $0.top.equalTo(thirdIcon)
        }
    }
    private func layoutFourthIcon(){
        addSubview(fourthIcon)
        fourthIcon.snp.makeConstraints {
            $0.leading.equalTo(photoView)
            $0.top.equalTo(thirdIcon.snp.bottom).offset(10)
            $0.size.equalTo(20)
        }
        addSubview(fourthLabel)
        fourthLabel.snp.makeConstraints {
            $0.leading.equalTo(fourthIcon.snp.trailing).offset(10)
            $0.top.equalTo(fourthIcon)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    func configure(with user: UserWrapper) {
        usernameLabel.text = user.name
        setUpImage(with: user.profileImageUrl.mediumImageUrl)
        manageLayouts(user: user)
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

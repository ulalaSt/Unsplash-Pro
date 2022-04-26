//
//  HomePhotoCell.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import UIKit

class HomePhotoCell: UICollectionViewCell {
    static let identifier = "HomePhotoCell"
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        return authorLabel
    }()
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()

    override func layoutSubviews() {
        addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
        
    }
    func configure(text: String, imageUrlString: String) {
        self.authorLabel.text = text
        PhotosServiceImplementation.getImage(urlString: imageUrlString) {[weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
}

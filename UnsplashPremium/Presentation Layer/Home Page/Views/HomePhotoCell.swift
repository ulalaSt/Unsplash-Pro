//
//  HomePhotoCell.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import UIKit
import SnapKit

typealias HomePhotoConfigurator = CollectionCellConfigurator<HomePhotoCell, Photo>

class HomePhotoCell: UICollectionViewCell {
    
    static let identifier = "HomePhotoCell"
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        return authorLabel
    }()
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.snp.makeConstraints {
//            $0.width.equalToSuperview()
//            $0.height.equalTo(600)
//        }
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}

extension HomePhotoCell: ConfigurableCell {
    func configure(data: Photo) {
        self.authorLabel.text = data.userName
        PhotosServiceImplementation.getImage(urlString: data.urlStringSmall) {[weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
    typealias DataType = Photo
}

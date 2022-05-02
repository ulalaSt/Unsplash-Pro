//
//  UserPhotoTableViewCell.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 30.04.2022.
//

import UIKit

typealias UserPhotoCellConfigurator = TableCellConfigurator<UserPhotoTableViewCell, UserPhotoCellData>

class UserPhotoTableViewCell: UITableViewCell, ConfigurableCell {

    typealias DataType = UserPhotoCellData

    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        layoutUI()
    }
    
    private func layoutUI() {
        contentView.addSubview(image)
        image.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: UserPhotoCellData) {
        PhotosServiceImplementation.getImage(urlString: data.url) {[weak self] result in
            switch result {
            case .success(let image):
                self?.image.image = image
                var view = self?.superview
                while (view != nil && (view as? UITableView) == nil) {
                  view = view?.superview
                }
                if let tableView = view as? UITableView {
                   tableView.beginUpdates()
                   tableView.endUpdates()
                }
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
}

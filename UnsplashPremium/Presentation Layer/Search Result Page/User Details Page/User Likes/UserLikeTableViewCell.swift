//
//  UserLikeTableViewCell.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 01.05.2022.
//

import UIKit

typealias UserLikeCellConfigurator = TableCellConfigurator<UserLikeTableViewCell, UserLikeCellData>

class UserLikeTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias DataType = UserLikeCellData
    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    let username = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    private func layoutUI() {
        contentView.addSubview(image)
        image.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.addSubview(username)
        username.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: UserLikeCellData) {
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
        username.text = data.username
    }
}

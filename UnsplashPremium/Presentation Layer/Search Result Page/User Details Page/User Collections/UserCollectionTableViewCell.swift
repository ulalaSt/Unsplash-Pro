//
//  UserCollectionTableViewCell.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 02.05.2022.
//

import UIKit

typealias UserCollectionCellConfigurator = TableCellConfigurator<UserCollectionTableViewCell, UserCollectionCellData>

class UserCollectionTableViewCell: UITableViewCell, ConfigurableCell {

    typealias DataType = UserCollectionCellData
    
    let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        layoutUI()
    }
    
    private func layoutUI() {
        contentView.addSubview(image)
        contentView.backgroundColor = .black
        image.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.centerX.centerY.equalToSuperview()
        }
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: UserCollectionCellData) {
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
        title.text = data.title
    }
}

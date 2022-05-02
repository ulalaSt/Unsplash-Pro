//
//  UserTableViewCell.swift
//  UnsplashPremium
//
//  Created by Lidiya Karnaukhova on 27.04.2022.
//

import UIKit

typealias UserCellConfigurator = TableCellConfigurator<UserTableViewCell, UserCellData>

class UserTableViewCell: UITableViewCell, ConfigurableCell {

    typealias DataType = UserCellData
    
    let image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return name
    }()
    
    let nickname: UILabel = {
        let nickname = UILabel()
        nickname.textColor = .lightGray
        nickname.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return nickname
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [name, nickname])
        stackView.spacing = 5
            
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        layoutUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.layer.cornerRadius = image.bounds.width / 2
        image.clipsToBounds = true
    }
    
    private func layoutUI() {
        contentView.addSubview(image)
        contentView.addSubview(stackView)
        
        image.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(50)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(image.snp.trailing).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: UserCellData) {
        PhotosServiceImplementation.getImage(urlString: data.profileImageUrl) {[weak self] result in
            switch result {
            case .success(let image):
                self?.image.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
        name.text = data.name
        nickname.text = data.nickname
    }
}

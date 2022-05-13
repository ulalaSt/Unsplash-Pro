
import UIKit
import SnapKit

typealias UnsplashLogoCellConfigurator = TableCellConfigurator<UnsplashLogoCell, String>

//MARK: - Photo Cell for Home Page

class UnsplashLogoCell: UITableViewCell {
    
    static let identifier = "UnsplashLogoCell"
    
    private let unsplashLogoView: UIImageView = {
        let unsplashLogoView = UIImageView()
        unsplashLogoView.contentMode = .scaleAspectFit
        unsplashLogoView.tintColor = .white
        let image = UIImage(named: "logo")
        unsplashLogoView.image = image?.withRenderingMode(.alwaysTemplate)
        return unsplashLogoView
    }()
    
    private let unsplashTitleView: UIImageView = {
        let unsplashTitleView = UIImageView()
        let image = UIImage(named: "unsplash")
        unsplashTitleView.image = image?.withRenderingMode(.alwaysTemplate)
        unsplashTitleView.tintColor = .white
        unsplashTitleView.contentMode = .scaleAspectFit
        return unsplashTitleView
    }()
    
    private let versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.textColor = .lightGray
        versionLabel.font = .systemFont(ofSize: 10, weight: .regular)
        return versionLabel
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .init(white: 0.1, alpha: 1)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(unsplashLogoView)
        unsplashLogoView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(30)
        }
        contentView.addSubview(unsplashTitleView)
        unsplashTitleView.snp.makeConstraints{
            $0.top.equalTo(unsplashLogoView.snp.bottom).offset(4)
            $0.height.equalTo(20)
            $0.centerX.equalTo(unsplashLogoView)
        }
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(unsplashTitleView.snp.bottom).offset(4)
            $0.centerX.equalTo(unsplashTitleView)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}



//MARK: - Set as Configurable Cell

extension UnsplashLogoCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        versionLabel.text = data
    }
}

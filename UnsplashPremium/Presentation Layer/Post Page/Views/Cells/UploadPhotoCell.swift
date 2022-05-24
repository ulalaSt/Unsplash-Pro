
import UIKit
import SnapKit

typealias UploadPhotoCellConfigurator = TableCellConfigurator<UploadPhotoCell, String>

//MARK: - Photo Cell for Home Page

class UploadPhotoCell: UITableViewCell {
    
    static let identifier = "UploadPhotoCell"
    
    private let backView: DashedLineView = {
        let backView = DashedLineView(lineCgColor: .init(gray: 0.5, alpha: 1))
        return backView
    }()
    
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "photo")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .lightGray
        return iconImageView
    }()
    
    private let bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        bottomLabel.textColor = .lightGray
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
        return bottomLabel
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
        contentView.addSubview(backView)
        backView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        backView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview().inset(30)
            $0.height.equalToSuperview().dividedBy(3)
        }
        backView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints{
            $0.top.equalTo(iconImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(60)
            $0.bottom.equalToSuperview()
        }
    }
}




//MARK: - Set as Configurable Cell

extension UploadPhotoCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        bottomLabel.text = data
    }
}


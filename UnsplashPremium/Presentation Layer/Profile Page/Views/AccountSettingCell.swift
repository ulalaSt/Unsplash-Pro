
import UIKit
import SnapKit

typealias AccountSettingCellConfigurator = TableCellConfigurator<AccountSettingCell, String>

//MARK: - Photo Cell for Home Page

class AccountSettingCell: UITableViewCell {
    
    static let identifier = "AccountSettingCell"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        return titleLabel
    }()
    
    private let nextIcon: UIImageView = {
        let nextIcon = UIImageView()
        let image = UIImage(systemName: "chevron.right")
        nextIcon.image = image
        nextIcon.contentMode = .scaleAspectFit
        nextIcon.tintColor = .lightGray
        return nextIcon
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "MediumGrayColor")
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(nextIcon)
        nextIcon.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(nextIcon.snp.leading).inset(10)
            $0.top.bottom.equalToSuperview()
        }
    }
}




//MARK: - Set as Configurable Cell

extension AccountSettingCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        titleLabel.text = data
    }
}


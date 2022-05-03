
import UIKit
import SnapKit

typealias InfoCellConfigurator = CollectionCellConfigurator<InfoCell,Info>

//MARK: - Photo Cell for Home Page

class InfoCell: UICollectionViewCell {
    
    static let identifier = "TopicPagePhotoCell"
    
    private let keyLabel: UILabel = {
        let keyLabel = UILabel()
        keyLabel.textColor = .lightGray
        keyLabel.font = .systemFont(ofSize: 10, weight: .regular)
        return keyLabel
    }()
    
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 15)
        return valueLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(keyLabel)
        keyLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2)
        }
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(keyLabel.snp.bottom)
        }
    }
}



//MARK: - Set as Configurable Cell

extension InfoCell: ConfigurableCell {
    
    typealias DataType = Info
    
    func configure(data: Info) {
        
        keyLabel.text = data.key.rawValue
        valueLabel.text = data.value
    }
}

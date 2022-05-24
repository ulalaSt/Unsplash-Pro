
import UIKit
import SnapKit

typealias FirstCollectionCellConfigurator = CollectionCellConfigurator<FirstCollectionCell, String>

//MARK: - Photo Cell for Home Page

class FirstCollectionCell: UICollectionViewCell {
    
    static let identifier = "FirstCollectionCell"
    
    private let blockIcon: UIImageView = {
        let blockImage = UIImage(systemName: "lock.fill")
        let blockIcon = UIImageView()
        blockIcon.image = blockImage
        blockIcon.contentMode = .scaleAspectFit
        blockIcon.tintColor = .white
        return blockIcon
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        authorLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return authorLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .black
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(5)
        }
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        contentView.addSubview(blockIcon)
        blockIcon.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(10)
            $0.size.equalTo(20)
        }
    }
}




//MARK: - Set as Configurable Cell

extension FirstCollectionCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        self.authorLabel.text = data
    }
}

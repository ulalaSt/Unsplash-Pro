
import UIKit
import SnapKit

typealias TitleRecommendationCellConfigurator = TableCellConfigurator<TitleRecommendationCell, String>

//MARK: - Photo Cell for Home Page

class TitleRecommendationCell: UITableViewCell {
    
    static let identifier = "TitleRecommendationCell"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 35, weight: .semibold)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
    }
}




//MARK: - Set as Configurable Cell

extension TitleRecommendationCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        self.titleLabel.text = data
    }
}


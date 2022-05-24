
import UIKit
import SnapKit

typealias TitleRecommendationCellConfigurator = TableCellConfigurator<TitleRecommendationCell, TitleCellData>

//MARK: - Photo Cell for Home Page

class TitleRecommendationCell: UITableViewCell {
    
    static let identifier = "TitleRecommendationCell"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
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
    
    typealias DataType = TitleCellData
    
    func configure(data: TitleCellData) {
        titleLabel.text = data.text
        titleLabel.font = data.textFont
        titleLabel.textColor = data.textColor
    }
}



import UIKit
import SnapKit

typealias TextInfoCellConfigurator = TableCellConfigurator<TextInfoCell, String>

//MARK: - Photo Cell for Home Page

class TextInfoCell: UITableViewCell {
    
    static let identifier = "InfoCell"
    
    private let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.textColor = .lightGray
        infoLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return infoLabel
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
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}



//MARK: - Set as Configurable Cell

extension TextInfoCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        infoLabel.text = data
    }
}

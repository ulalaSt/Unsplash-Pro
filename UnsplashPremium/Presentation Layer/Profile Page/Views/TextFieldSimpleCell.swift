
import UIKit
import SnapKit

typealias TextFieldSimpleCellConfigurator = TableCellConfigurator<TextFieldSimpleCell, TextFieldSimpleData>

//MARK: - Photo Cell for Home Page

class TextFieldSimpleCell: UITableViewCell {
    
    static let identifier = "TextFieldSimpleCell"
        
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.backgroundColor = .clear
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: ColorKeys.mediumGray)
        textField.delegate = self
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
}




//MARK: - Set as Configurable Cell

extension TextFieldSimpleCell: ConfigurableCell {
    
    typealias DataType = TextFieldSimpleData

    func configure(data: TextFieldSimpleData) {
        textField.text = data.text
        if let placeholder = data.placeHolder {
            let attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold),
                    NSAttributedString.Key.foregroundColor : UIColor.lightGray
                ])
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }
}

extension TextFieldSimpleCell: UITextFieldDelegate {
    
}

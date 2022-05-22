
import UIKit
import SnapKit

typealias TextFieldCellConfigurator = TableCellConfigurator<TextFieldCell, TextFieldData>

//MARK: - Photo Cell for Home Page

class TextFieldCell: UITableViewCell {
    
    static let identifier = "TextFieldCell"
    
    var currentData: TextFieldData?
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.backgroundColor = .clear
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .gray
        textField.delegate = self
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
    }
    @objc private func textFieldDidChange(){
        currentData?.text = textField.text
        Action.custom("textFieldDidChange").invoke(cell: self)
    }
}




//MARK: - Set as Configurable Cell

extension TextFieldCell: ConfigurableCell {
    
    typealias DataType = TextFieldData

    func configure(data: TextFieldData) {
        currentData = data
        textField.text = data.text
        if let placeholder = data.thingToChange.placeHolder {
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

extension TextFieldCell: UITextFieldDelegate {
    
}

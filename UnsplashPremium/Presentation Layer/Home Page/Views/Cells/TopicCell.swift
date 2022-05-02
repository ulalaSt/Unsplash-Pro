
import UIKit
import SnapKit


//MARK: - Each Topic Displayed in Topic Bar

class TopicCell: UICollectionViewCell {
    
    private let topicLabel: UILabel = {
        let topicLabel = UILabel()
        topicLabel.textColor = .white
        return topicLabel
    }()
    
    private let movableHorizontalLine: UIView = {
        let movableHorizontalLine = UIView()
        movableHorizontalLine.backgroundColor = UIColor(white: 1, alpha: 0)
        return movableHorizontalLine
    }()
    
    func setLabeltext(with text: String) {
        self.topicLabel.text = text
    }
    
    //initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear.withAlphaComponent(0)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        addSubview(topicLabel)
        topicLabel.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(50)
        }
        addSubview(movableHorizontalLine)
        movableHorizontalLine.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(self)
            $0.height.equalTo(4)
        }
    }
    
    
    // sets horizontal line color if the cell is seleected
    override var isSelected: Bool {
        didSet {
            movableHorizontalLine.backgroundColor = isSelected ? UIColor(white: 1, alpha: 1) : UIColor(white: 1, alpha: 0)
        }
    }
}

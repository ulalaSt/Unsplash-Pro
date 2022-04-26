//
//  MenuCell.swift
//  UnsplashPremium
//
//  Created by user on 26.04.2022.
//

import UIKit
import SnapKit

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear.withAlphaComponent(0)
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
    override var isHighlighted: Bool {
        didSet {
            
        }
    }
    override var isSelected: Bool {
        didSet {
            movableHorizontalLine.backgroundColor = isSelected ? UIColor(white: 1, alpha: 1) : UIColor(white: 1, alpha: 0)
        }
    }
    
    func setLabeltext(with text: String) {
        self.topicLabel.text = text
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

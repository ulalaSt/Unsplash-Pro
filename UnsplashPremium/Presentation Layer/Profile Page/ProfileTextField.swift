//
//  ProfileTextField.swift
//  UnsplashPremium
//
//  Created by user on 16.05.2022.
//

import UIKit
import SnapKit

class ProfileTextField: UITextField {
    private let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .gray
        return bottomLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .white
        borderStyle = .none
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}

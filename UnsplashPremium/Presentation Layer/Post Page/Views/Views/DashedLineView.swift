//
//  DashedView.swift
//  UnsplashPremium
//
//  Created by user on 16.05.2022.
//

import UIKit

class DashedLineView: UIView {

    private let borderLayer: CAShapeLayer = {
        let borderLayer = CAShapeLayer()
        borderLayer.lineDashPattern = [8,8]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        return borderLayer
    }()
    
    init (lineCgColor: CGColor) {
        super.init(frame: .zero)
        borderLayer.strokeColor = lineCgColor
        layer.addSublayer(borderLayer)
    }
    override func layoutSubviews() {
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

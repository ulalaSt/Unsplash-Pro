
import UIKit


//MARK: - Gradient View to Make Contents More Readable

class GradientView: UIView {

    private let gradient : CAGradientLayer = CAGradientLayer()
    
    private let gradientColor: UIColor

    init(gradientColor: UIColor) {
        self.gradientColor = gradientColor
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = [
            gradientColor.withAlphaComponent(0.7).cgColor,
            gradientColor.withAlphaComponent(0.0).cgColor
        ]
        gradient.locations = [NSNumber(value: 0.2),NSNumber(value: 1.0)]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}

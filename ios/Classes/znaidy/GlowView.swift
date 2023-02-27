//
//  GlowView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 18.02.2023.
//

import Foundation

class GlowView: UIView, CAAnimationDelegate {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.type = .radial
        l.colors = [
            ZnaidyConstants.znaidyBlue.cgColor,
            ZnaidyConstants.znaidyBlue.withAlphaComponent(0.0).cgColor
        ]
        l.locations = [ 0, 0.6 ]
        l.startPoint = CGPoint(x: 0.5, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(l)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.width / 2.0
    }
    
    func startAnimation() {
        let colorsAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        colorsAnimation.fromValue = gradientLayer.locations
        colorsAnimation.toValue = [0, 0.85]
        colorsAnimation.duration = 0.75
        colorsAnimation.delegate = self
        colorsAnimation.fillMode = .forwards
        colorsAnimation.repeatCount = .infinity
        colorsAnimation.autoreverses = true
        gradientLayer.add(colorsAnimation, forKey: "glow")
    }
    
    func stopAnimation() {
        gradientLayer.removeAnimation(forKey: "glow")
    }
    
    func setColor(color: UIColor) {
        stopAnimation()
        gradientLayer.colors = [
            color.cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
    }
    
}

//
//  ZnaidySpeedView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 18.02.2023.
//

import Foundation
import UIKit

class ZnaidySpeedView : UIView {
    
    private var speedLabel: UILabel!
    private var unitsLabel: UILabel!
    
    var speed: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = ZnaidyConstants.znaidyBlack
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        speedLabel = UILabel()
        speedLabel.text = "2"
        speedLabel.textColor = ZnaidyConstants.mainTextColor
        speedLabel.textAlignment = .center
        speedLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedLabel)
        unitsLabel = UILabel()
        unitsLabel.text = "km/h"
        unitsLabel.textColor = ZnaidyConstants.secondaryTextColor
        unitsLabel.textAlignment = .center
        unitsLabel.font = .systemFont(ofSize: 8)
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitsLabel)
        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            speedLabel.bottomAnchor.constraint(equalTo: unitsLabel.topAnchor, constant: 2),
            unitsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            unitsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])
    }
    
    func setZoomFactor(zoomFactor: Double) {
        if (zoomFactor >= 1.0) {
            speedLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            unitsLabel.font = .systemFont(ofSize: 8)
        } else {
            speedLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.bold)
            unitsLabel.font = .systemFont(ofSize: 6)
        }
    }
    
    func setSpeed(speed: Int) {
        self.speed = speed
        speedLabel.text = "\(speed)"
    }
    
    

}

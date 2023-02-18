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
        speedLabel.textColor = .white
        speedLabel.textAlignment = .center
        speedLabel.font = .systemFont(ofSize: 13)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedLabel)
        unitsLabel = UILabel()
        unitsLabel.text = "km/h"
        unitsLabel.textColor = .white
        unitsLabel.textAlignment = .center
        unitsLabel.font = .systemFont(ofSize: 6)
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitsLabel)
        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            speedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            unitsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            unitsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])
    }
    
    func setSpeed(speed: Int) {
        speedLabel.text = "\(speed)"
    }

}

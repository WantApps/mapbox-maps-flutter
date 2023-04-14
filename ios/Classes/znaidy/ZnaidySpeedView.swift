//
//  ZnaidySpeedView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 18.02.2023.
//

import Foundation
import UIKit

class ZnaidySpeedView : UIView {
    private var backgroundView: UIImageView!
    private var speedLabel: UILabel!
    private var unitsLabel: UILabel!
    
    private var bottomOffset: NSLayoutConstraint!
    
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
        backgroundView = UIImageView(image: MediaProvider.image(named: "speed_background"))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        translatesAutoresizingMaskIntoConstraints = false
        speedLabel = UILabel()
        speedLabel.text = "2"
        speedLabel.textColor = ZnaidyConstants.mainTextColor
        speedLabel.textAlignment = .center
        speedLabel.font = MediaProvider.getFont(ofSize: ZnaidyConstants.currentSpeedSpeedFontSize, weight: .bold)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedLabel)
        unitsLabel = UILabel()
        unitsLabel.text = Localizaton.localize(key: "speed_units")
        unitsLabel.textColor = ZnaidyConstants.secondaryTextColor
        unitsLabel.textAlignment = .center
        unitsLabel.font = MediaProvider.getFont(ofSize: ZnaidyConstants.currentSpeedUnitFontSize, weight: .heavy)
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitsLabel)
        
        bottomOffset = unitsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),

            speedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            speedLabel.bottomAnchor.constraint(equalTo: unitsLabel.topAnchor, constant: 2),
            unitsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomOffset,
        ])
    }
    
    func setZoomFactor(zoomFactor: Double) {
        speedLabel.font = MediaProvider.getFont(ofSize: ZnaidyConstants.currentSpeedSpeedFontSize * zoomFactor, weight: .bold)
        unitsLabel.font = MediaProvider.getFont(ofSize: ZnaidyConstants.currentSpeedUnitFontSize * zoomFactor, weight: .heavy)
        bottomOffset.constant = -2 * zoomFactor
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func setSpeed(speed: Int) {
        self.speed = speed
        speedLabel.text = "\(speed)"
    }
    
    

}

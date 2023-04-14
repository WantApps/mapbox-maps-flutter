//
//  ZnaidyBatteryView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 15.03.2023.
//

import Foundation
import UIKit

class ZnaidyBatteryView : UIView {
    
    private var backgroundView: UIImageView!
    private var batteryIcon: UIImageView!
    private var batteryText: UILabel!
    
    private var batteryIconWidth: NSLayoutConstraint!
    private var batteryIconHeight: NSLayoutConstraint!
    private var batteryTextBottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundView = UIImageView(image: MediaProvider.image(named: "battery_background"))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        translatesAutoresizingMaskIntoConstraints = false
        batteryIcon = UIImageView()
        batteryIcon.translatesAutoresizingMaskIntoConstraints = false
        batteryIcon.contentMode = .scaleAspectFit
        addSubview(batteryIcon)
        batteryText = UILabel()
        batteryText.textColor = ZnaidyConstants.secondaryTextColor
        batteryText.textAlignment = .center
        batteryText.lineBreakMode = .byClipping
        batteryText.font = MediaProvider.getFont(ofSize: ZnaidyConstants.batteryFontSize, weight: .bold)
        batteryText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(batteryText)
        
        batteryIconWidth = batteryIcon.widthAnchor.constraint(equalToConstant: ZnaidyConstants.batteryIconSize)
        batteryIconHeight = batteryIcon.heightAnchor.constraint(equalToConstant: ZnaidyConstants.batteryIconSize)
        batteryTextBottomConstraint = batteryText.bottomAnchor.constraint(equalTo: batteryIcon.topAnchor, constant: 2)
        
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            
            batteryIconWidth,
            batteryIconHeight,
            batteryIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            batteryIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            batteryText.centerXAnchor.constraint(equalTo: centerXAnchor),
            batteryTextBottomConstraint
        ])
    }
    
    func setZoomFactor(zoomFactor: Double) {
        batteryText.font = MediaProvider.getFont(ofSize: ZnaidyConstants.batteryFontSize * zoomFactor, weight: .bold)
        
        batteryIconWidth.constant = ZnaidyConstants.batteryIconSize * zoomFactor
        batteryIconHeight.constant = ZnaidyConstants.batteryIconSize * zoomFactor
        batteryTextBottomConstraint.constant = 2.5 * zoomFactor
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func setBatteryLevel(level: Int, charging: Bool) {
        batteryIcon.image = MediaProvider.image(named: getImageName(level: level, charging: charging))
        batteryText.textColor = getTextColor(level: level, charging: charging)
        batteryText.text = "\(max(level, 0))%"
    }
    
    private func getImageName(level: Int, charging: Bool) -> String {
        if (charging) {
            return "battery_charging"
        } else if (0...20 ~= level) {
            return "battery_low"
        } else {
            return "battery_default"
        }
    }
    
    private func getTextColor(level: Int, charging: Bool) -> UIColor {
        if (0...20 ~= level) {
            return ZnaidyConstants.batteryLowColor
        } else {
            return UIColor.black
        }
    }
    
}

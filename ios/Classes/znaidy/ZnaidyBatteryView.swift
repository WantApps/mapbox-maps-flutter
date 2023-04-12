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
        batteryText.font = MediaProvider.getFont(ofSize: 10, weight: .bold)
        batteryText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(batteryText)
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            
            batteryIcon.widthAnchor.constraint(equalToConstant: 13),
            batteryIcon.heightAnchor.constraint(equalToConstant: 13),
            batteryIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            batteryIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            batteryText.centerXAnchor.constraint(equalTo: centerXAnchor),
            batteryText.bottomAnchor.constraint(equalTo: batteryIcon.topAnchor)
        ])
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

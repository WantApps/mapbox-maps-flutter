//
//  ZnaidyBatteryView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 15.03.2023.
//

import Foundation
import UIKit

class ZnaidyBatteryView : UIView {
    
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
        translatesAutoresizingMaskIntoConstraints = false
        batteryIcon = UIImageView()
        batteryIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(batteryIcon)
        batteryText = UILabel()
        batteryText.textColor = ZnaidyConstants.secondaryTextColor
        batteryText.textAlignment = .center
        batteryText.lineBreakMode = .byClipping
        batteryText.font = .systemFont(ofSize: 14, weight: .bold)
        batteryText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(batteryText)
        NSLayoutConstraint.activate([
            batteryIcon.widthAnchor.constraint(equalToConstant: 30),
            batteryIcon.heightAnchor.constraint(equalToConstant: 30),
            batteryIcon.leftAnchor.constraint(equalTo: leftAnchor),
            batteryIcon.topAnchor.constraint(equalTo: topAnchor),
            batteryIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            batteryText.topAnchor.constraint(equalTo: topAnchor),
            batteryText.bottomAnchor.constraint(equalTo: bottomAnchor),
            batteryText.rightAnchor.constraint(equalTo: rightAnchor),
            batteryText.leftAnchor.constraint(equalTo: batteryIcon.rightAnchor)
        ])
    }
    
    func setBatteryLevel(level: Int, charging: Bool) {
        batteryIcon.image = MediaProvider.image(named: getImageName(level: level, charging: charging))
        batteryText.textColor = getTextColor(level: level, charging: charging)
        batteryText.text = "\(level)%"
    }
    
    private func getImageName(level: Int, charging: Bool) -> String {
        if (charging) {
            return "icon_battery_capsule_plugged"
        } else if (level == 0) {
            return "icon_battery_capsule_unplugged_0"
        } else if (0...20 ~= level) {
            return "icon_battery_capsule_unplugged_1"
        } else if (20...50 ~= level) {
            return "icon_battery_capsule_unplugged_2"
        } else if (50...90 ~= level) {
            return "icon_battery_capsule_unplugged_3"
        } else if (90...100 ~= level) {
            return "icon_battery_capsule_unplugged_4"
        }
        return "icon_battery_capsule_unplugged_4"
    }
    
    private func getTextColor(level: Int, charging: Bool) -> UIColor {
        if (charging) {
            return ZnaidyConstants.batteryChargingColor
        } else if (0...20 ~= level) {
            return ZnaidyConstants.batteryLowColor
        } else {
            return ZnaidyConstants.mainTextColor
        }
    }
    
}

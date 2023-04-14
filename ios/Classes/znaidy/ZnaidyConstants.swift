//
//  ZnaidyConstants.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 17.02.2023.
//

import Foundation

class ZnaidyConstants {
    
    static let annotationWidth = 150.0
    static let annotationHeight = 162.0
    
    static let markerOffsetY = 34.0
    
    static let markerWidth = 68.0
    static let markerHeight = 76.0
    
    static let avatarSize = 64.0
    static let avatarOffset = -4.0
    
    static let stickerCountSize = 20.0
    static let stickersHorizontalOffset = 5.0
    
    static let companyCountSize = 24.0
    
    static let currentSpeedSize = 30.0
    static let currentSpeedVerticalOffset = 0.0
    static let currentSpeedHorizontalOffset = -13.0
    static let currentSpeedHorizontalOffsetSmall = -9.0
    static let currentSpeedSpeedFontSize = 12.5
    static let currentSpeedUnitFontSize = 6.25

    static let inAppWidth = 46.0 * 1.2
    static let inAppHeight = 22.0 * 1.2
    static let inAppVerticalOffset = markerOffsetY + (markerHeight * 1.2) + 6.0
    static let inAppFont = 10.0 * 1.2
    
    static let batterySize = 30.0
    static let batteryHoryzontalOffset = 13.0
    static let batteryFontSize = 10.0
    static let batteryIconSize = 13.0
    
    static let offlineTimeWidth = 64.0
    static let offlineTimeHeight = 30.0
    static let offlineTimeVerticalOffset = markerOffsetY + markerHeight + 6.0
    
    static let znaidyBlue = UIColor(red: 0.0, green: 155.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    static let inAppColor = UIColor(red: 184.0/255.0, green: 78.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    static let znaidyGray = UIColor(red: 188.0/256.0, green: 171.0/255.0, blue: 174.0/255.0, alpha: 1.0)
    static let znaidyBlack = UIColor(red: 27.0/255.0, green: 27.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    static let mainTextColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
    static let secondaryTextColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 0.7)
    static let batteryChargingColor = UIColor(red: 142.0/255.0, green: 158.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    static let batteryLowColor = UIColor(red: 197.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let inAppGlowInColor = UIColor(red: 0.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
    static let inAppGlowOutColor = UIColor(red: 184.0/255.0, green: 78.0/255.0, blue: 250.0/250.0, alpha: 0.4)
    static let onlineGlowColor = UIColor(red: 38.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.25)
}

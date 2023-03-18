//
//  ZnaidyAnnotationData.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 16.02.2023.
//

import Foundation
import Turf
import MapboxMaps

class ZnaidyAnnotationData {
    init(id: String, geometry: CLLocationCoordinate2D, markerType: ZnaidyMarkerType, onlineStatus: ZnaidyOnlineStatus, avatartUrls: [String], stickerCount: Int, companySize: Int, currentSpeed: Int, batteryLevel: Int, batteryCharging: Bool, focused: Bool) {
        self.id = id
        self.geometry = geometry
        self.markerType = markerType
        self.onlineStatus = onlineStatus
        self.avatarUrls = avatartUrls
        self.stickerCount = stickerCount
        self.companySize = companySize
        self.currentSpeed = currentSpeed
        self.batteryLevel = batteryLevel
        self.batteryCharging = batteryCharging
        self.focused = focused
    }
    
    let id: String
    let geometry: CLLocationCoordinate2D
    let markerType: ZnaidyMarkerType
    let onlineStatus: ZnaidyOnlineStatus
    let avatarUrls: [String]
    let stickerCount: Int
    let companySize: Int
    let currentSpeed: Int
    let batteryLevel: Int
    let batteryCharging: Bool
    let focused: Bool
    
    func userAvatar() -> String? {
        return avatarUrls.first
    }
    
    func toString() -> String {
        return "ZnaidyAnnotationData(id=\(id), geometry=\(geometry), type=\(markerType), status=\(onlineStatus), avatars\(avatarUrls), stickers=\(stickerCount), company=\(companySize), speed=\(currentSpeed), batteryLevel=\(batteryLevel), batteryCharging=\(batteryCharging), focused=\(focused))"
    }
}

enum ZnaidyOnlineStatus: Int {
    case online = 1
    case inApp = 2
    case offline = 3
}

enum ZnaidyMarkerType: Int {
    case _self = 1
    case friend = 2
    case company = 3
}

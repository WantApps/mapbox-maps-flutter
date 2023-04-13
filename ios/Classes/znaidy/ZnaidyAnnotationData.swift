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
    init(id: String, userId: String, geometry: CLLocationCoordinate2D, markerType: ZnaidyMarkerType, markerStyle: ZnaidyMarkerStyle, onlineStatus: ZnaidyOnlineStatus, avatartUrls: [String], stickerCount: Int, companySize: Int, currentSpeed: Int, batteryLevel: Int, batteryCharging: Bool, lastOnline: Int?, focused: Bool) {
        self.id = id
        self.userId = userId
        self.geometry = geometry
        self.markerType = markerType
        self.markerStyle = markerStyle
        self.onlineStatus = onlineStatus
        self.avatarUrls = avatartUrls
        self.stickerCount = stickerCount
        self.companySize = companySize
        self.currentSpeed = currentSpeed
        self.batteryLevel = batteryLevel
        self.batteryCharging = batteryCharging
        self.lastOnline = lastOnline ?? 0
        self.focused = focused
    }
    
    let id: String
    let userId: String
    let geometry: CLLocationCoordinate2D
    let markerType: ZnaidyMarkerType
    let markerStyle: ZnaidyMarkerStyle
    let onlineStatus: ZnaidyOnlineStatus
    let avatarUrls: [String]
    let stickerCount: Int
    let companySize: Int
    let currentSpeed: Int
    let batteryLevel: Int
    let batteryCharging: Bool
    let lastOnline: Int
    let focused: Bool
    
    func userAvatar() -> String? {
        return avatarUrls.first
    }
    
    func offlineTime() -> Int {
        return Int(Date().timeIntervalSince1970 - Double(lastOnline / 1000))
    }
    
    private let zoomSteps = [0.2, 0.5, 0.8, 1.0, 1.2]
    
    func applyZoomFactor(zoomFactor: Double) -> Double {
        var factor = zoomFactor
        if (focused) {
            factor = 1.2
        } else if (markerType == ._self) {
            factor = max(zoomFactor, 0.5)
        } else {
            factor = max(zoomFactor, 0.2)
        }
        if (onlineStatus == .offline) {
            factor = zoomSteps[max((zoomSteps.firstIndex(of: factor) ?? 0) - 1, 0)]
        }
        return factor
    }
    
    func toString() -> String {
        return "ZnaidyAnnotationData(id=\(id), userId=\(userId), geometry=\(geometry), type=\(markerType), style=\(markerStyle), status=\(onlineStatus), avatars\(avatarUrls), stickers=\(stickerCount), company=\(companySize), speed=\(currentSpeed), batteryLevel=\(batteryLevel), batteryCharging=\(batteryCharging), lastOnline=\(lastOnline), focused=\(focused))"
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

enum ZnaidyMarkerStyle: String {
    case _default = "default"
    case preOrder = "pre_order"
    
    func getImageName() -> String {
        switch(self) {
            case ._default:
                return "marker_default"
            case .preOrder:
                return "marker_pre_order"
        }
    }
}

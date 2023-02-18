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
    init(id: String, geometry: CLLocationCoordinate2D, markerType: ZnaidyMarkerType, onlineStatus: ZnaidyOnlineStatus, avatartUrls: [String], stickerCount: Int, companySize: Int, currentSpeed: Int, focused: Bool) {
        self.id = id
        self.geometry = geometry
        self.markerType = markerType
        self.onlineStatus = onlineStatus
        self.avatarUrls = avatartUrls
        self.stickerCount = stickerCount
        self.companySize = companySize
        self.currentSpeed = currentSpeed
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
    let focused: Bool
    
    func toString() -> String {
        return "ZnaidyAnnotationData(id=\(id), geometry=\(geometry), type=\(markerType), status=\(onlineStatus), avatars\(avatarUrls), stickers=\(stickerCount), company=\(companySize), speed=\(currentSpeed), focused=\(focused))"
    }
}

enum ZnaidyOnlineStatus: Int {
    case online = 0
    case inApp = 1
    case offline = 2
}

enum ZnaidyMarkerType: Int {
    case _self = 0
    case friend = 1
    case company = 2
}

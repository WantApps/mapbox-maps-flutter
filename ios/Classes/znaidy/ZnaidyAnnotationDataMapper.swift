//
//  ZnaidyAnnotationDataMapper.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 16.02.2023.
//

import Foundation
import CoreLocation

class ZnaidyAnnotationDataMapper {
    
    static func createAnnotation(id: String, options: FLTZnaidyAnnotationOptions) -> ZnaidyAnnotationData {
        return ZnaidyAnnotationData(
            id: id,
            geometry: convertDictionaryToCLLocationCoordinate2D(dict: options.geometry) ?? CLLocationCoordinate2D.init(latitude: 0, longitude: 0),
            markerType: ZnaidyMarkerType(rawValue: Int(options.markerType.rawValue)) ?? ZnaidyMarkerType.friend,
            onlineStatus: ZnaidyOnlineStatus(rawValue: Int(options.onlineStatus.rawValue)) ?? ZnaidyOnlineStatus.offline,
            avatartUrls: options.userAvatars ?? [],
            stickerCount: Int(truncating: options.stickerCount ?? 0),
            companySize: Int(truncating: options.companySize ?? 0),
            currentSpeed: Int(truncating: options.currentSpeed ?? 0),
            zoomFactor: Double(truncating: options.zoomFactor ?? 1.0),
            focused: false
        )
    }
    
    static func coordinatesFromOptions(options: FLTZnaidyAnnotationOptions) -> CLLocationCoordinate2D {
        return convertDictionaryToCLLocationCoordinate2D(dict: options.geometry) ?? CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
    }
    
    static func updateAnnotation(data: ZnaidyAnnotationData, options: FLTZnaidyAnnotationOptions) -> ZnaidyAnnotationData {
        return ZnaidyAnnotationData(
            id: data.id,
            geometry: convertDictionaryToCLLocationCoordinate2D(dict: options.geometry) ?? data.geometry,
            markerType: ZnaidyMarkerType(rawValue: Int(options.markerType.rawValue)) ?? data.markerType,
            onlineStatus: ZnaidyOnlineStatus(rawValue: Int(options.onlineStatus.rawValue)) ?? data.onlineStatus,
            avatartUrls: options.userAvatars ?? data.avatarUrls,
            stickerCount: Int(truncating: options.stickerCount ?? data.stickerCount as NSNumber),
            companySize: Int(truncating: options.companySize ?? data.companySize as NSNumber),
            currentSpeed: Int(truncating: options.currentSpeed ?? data.currentSpeed as NSNumber),
            zoomFactor: Double(truncating: options.zoomFactor ?? data.zoomFactor as NSNumber),
            focused: data.focused
        )
    }
    
    static func udpateAnnotationFocused(data: ZnaidyAnnotationData, focused: Bool) -> ZnaidyAnnotationData {
        return ZnaidyAnnotationData(
            id: data.id,
            geometry: data.geometry,
            markerType: data.markerType,
            onlineStatus: data.onlineStatus,
            avatartUrls: data.avatarUrls,
            stickerCount: data.stickerCount,
            companySize: data.companySize,
            currentSpeed: data.currentSpeed,
            zoomFactor: data.zoomFactor,
            focused: focused
        )
    }
    
    static func mapToOptions(data: ZnaidyAnnotationData) -> FLTZnaidyAnnotationOptions {
        return FLTZnaidyAnnotationOptions.make(
            withGeometry: data.geometry.toDict(),
            markerType: FLTMarkerType(rawValue: UInt(data.markerType.rawValue))!,
            onlineStatus: FLTOnlineStatus(rawValue: UInt(data.onlineStatus.rawValue))!,
            userAvatars: nil,
            stickerCount: nil,
            companySize: nil,
            currentSpeed: nil,
            zoomFactor: nil
        )
    }
}

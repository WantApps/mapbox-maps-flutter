package com.mapbox.maps.mapbox_maps.annotation.znaidy

import com.mapbox.geojson.Point
import com.mapbox.maps.mapbox_maps.toMap
import com.mapbox.maps.mapbox_maps.toPoint
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.MarkerType
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.OnlineStatus
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions

object ZnaidyAnnotationDataMapper {

  fun createAnnotation(id: String, options: ZnaidyAnnotationOptions): ZnaidyAnnotationData {
    return ZnaidyAnnotationData(
      id,
      options.geometry?.toPoint() ?: Point.fromLngLat(0.0, 0.0),
      options.markerType?.let { mapFromTunnelMarkerType(it) } ?: ZnaidyMarkerType.FRIEND,
      options.onlineStatus?.let { mapFromTunnelOnlineStatus(it) }
        ?: ZnaidyOnlineStatus.OFFLINE,
      options.userAvatars ?: listOf(),
      options.stickerCount?.toInt() ?: 0,
      options.companySize?.toInt() ?: 0,
      options.currentSpeed?.toInt() ?: 0,
      options.batteryLevel?.toInt() ?: 0,
      options.batteryCharging ?: false,
    )
  }

  fun geometryFromOptions(options: ZnaidyAnnotationOptions): Point {
    return options.geometry?.toPoint() ?: Point.fromLngLat(0.0, 0.0)
  }

  fun updateAnnotation(
    data: ZnaidyAnnotationData,
    options: ZnaidyAnnotationOptions
  ): ZnaidyAnnotationData {
    return data.copy(
      geometry = options.geometry?.toPoint() ?: data.geometry,
      markerType = options.markerType?.let {
        if (it != MarkerType.none) {
          mapFromTunnelMarkerType(it)
        } else {
          data.markerType
        }
      } ?: data.markerType,
      onlineStatus = options.onlineStatus?.let {
        if (it != OnlineStatus.none) {
          mapFromTunnelOnlineStatus(it)
        } else {
          data.onlineStatus
        }
      } ?: data.onlineStatus,
      avatarUrls = options.userAvatars ?: data.avatarUrls,
      stickersCount = options.stickerCount?.toInt() ?: data.stickersCount,
      companySize = options.companySize?.toInt() ?: data.companySize,
      currentSpeed = options.currentSpeed?.toInt() ?: data.currentSpeed,
      batteryLevel = options.batteryLevel?.toInt() ?: data.batteryLevel,
      batteryCharging = options.batteryCharging ?: data.batteryCharging,
    )
  }

  fun mapToOptions(data: ZnaidyAnnotationData): ZnaidyAnnotationOptions {
    return ZnaidyAnnotationOptions.Builder().apply {
      setGeometry(data.geometry.toMap())
    }.build()
  }

  private fun mapFromTunnelOnlineStatus(status: OnlineStatus): ZnaidyOnlineStatus {
    return ZnaidyOnlineStatus.valueOf(status.name.uppercase())
  }

  private fun mapToTunnelMarkerType(markerType: ZnaidyMarkerType): MarkerType {
    return MarkerType.valueOf(markerType.name.lowercase())
  }

  private fun mapFromTunnelMarkerType(markerType: MarkerType): ZnaidyMarkerType {
    return ZnaidyMarkerType.valueOf(markerType.name.uppercase())
  }
}
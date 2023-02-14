package com.mapbox.maps.mapbox_maps.annotation.znaidy

import com.mapbox.geojson.Geometry
import com.mapbox.geojson.Point
import com.mapbox.maps.mapbox_maps.toMap
import com.mapbox.maps.mapbox_maps.toPoint
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.OnlineStatus
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions

object ZnaidyAnnotationDataMapper {

  fun createAnnotation(id: String, options: ZnaidyAnnotationOptions): ZnaidyAnnotationData {
    return ZnaidyAnnotationData(
      id,
      options.geometry?.toPoint() ?: Point.fromLngLat(0.0, 0.0),
      options.isSelf ?: false,
      options.onlineStatus?.let { mapFromTunnelOnlineStatus(it) }
        ?: ZnaidyOnlineStatus.OFFLINE,
      options.userAvatars ?: listOf(),
      options.stickerCount?.toInt() ?: 0,
      options.companySize?.toInt() ?: 0,
      options.currentSpeed?.toInt() ?: 0,
    )
  }

  fun geometryFromOptions(options: ZnaidyAnnotationOptions): Point {
    return options.geometry?.toPoint() ?: Point.fromLngLat(0.0, 0.0)
  }

  fun updateAnnotation(data: ZnaidyAnnotationData, options: ZnaidyAnnotationOptions): ZnaidyAnnotationData {
    return data.copy(
      isSelf = options.isSelf ?: data.isSelf,
      geometry = options.geometry?.toPoint() ?: data.geometry,
      onlineStatus = options.onlineStatus?.let { mapFromTunnelOnlineStatus(it) } ?: data.onlineStatus,
      avatarUrls = options.userAvatars ?: data.avatarUrls,
      stickersCount = options.stickerCount?.toInt() ?: data.stickersCount,
      companySize = options.companySize?.toInt() ?: data.companySize,
      currentSpeed = options.currentSpeed?.toInt() ?: data.currentSpeed,
    )
  }

  fun mapToOptions(data: ZnaidyAnnotationData): ZnaidyAnnotationOptions {
    return ZnaidyAnnotationOptions.Builder().apply {
      setGeometry(data.geometry.toMap())
    }.build()
  }

  private fun mapToTunnelOnlineStatus(status: ZnaidyOnlineStatus): OnlineStatus {
    return when(status) {
      ZnaidyOnlineStatus.ONLINE -> OnlineStatus.online
      ZnaidyOnlineStatus.INAPP -> OnlineStatus.inApp
      ZnaidyOnlineStatus.OFFLINE -> OnlineStatus.offline
    }
  }

  private fun mapFromTunnelOnlineStatus(status: OnlineStatus): ZnaidyOnlineStatus {
    return ZnaidyOnlineStatus.valueOf(status.name.uppercase())
  }
}
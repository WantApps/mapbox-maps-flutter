package com.mapbox.maps.mapbox_maps.annotation.znaidy

import com.mapbox.geojson.Point
import com.mapbox.maps.mapbox_maps.toPoint
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.OnlineStatus
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions

object ZnaidyAnnotationDataMapper {

  fun createAnnotation(id: String, options: ZnaidyAnnotationOptions): ZnaidyAnnotationData {
    return ZnaidyAnnotationData(
      id,
      options.geometry?.toPoint() ?: Point.fromLngLat(0.0, 0.0),
      options.onlineStatus?.let { mapFromTunnelOnlineStatus(it) }
        ?: ZnaidyOnlineStatus.OFFLINE,
      options.userAvatar ?: "",
      options.stickerCount?.toInt() ?: 0,
      options.companySize?.toInt() ?: 0,
      options.currentSpeed?.toInt() ?: 0,
    )
  }

  fun updateAnnotation(data: ZnaidyAnnotationData, options: ZnaidyAnnotationOptions): ZnaidyAnnotationData {
    return data.copy(
      geometry = options.geometry?.toPoint() ?: data.geometry,
      onlineStatus = options.onlineStatus?.let { mapFromTunnelOnlineStatus(it) } ?: data.onlineStatus,
      avatarUrl = options.userAvatar ?: data.avatarUrl,
      stickersCount = options.stickerCount?.toInt() ?: data.stickersCount,
      companySize = options.companySize?.toInt() ?: data.companySize,
      currentSpeed = options.currentSpeed?.toInt() ?: data.currentSpeed,
    )
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
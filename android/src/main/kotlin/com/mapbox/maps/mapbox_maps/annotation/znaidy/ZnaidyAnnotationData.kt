package com.mapbox.maps.mapbox_maps.annotation.znaidy

import com.mapbox.geojson.Point

data class ZnaidyAnnotationData(
  val id: String,
  val geometry: Point,
  val onlineStatus: ZnaidyOnlineStatus,
  val avatarUrl: String,
  val stickersCount: Int,
  val companySize: Int,
  val currentSpeed: Int,
)

enum class ZnaidyOnlineStatus {
  ONLINE,
  INAPP,
  OFFLINE
}

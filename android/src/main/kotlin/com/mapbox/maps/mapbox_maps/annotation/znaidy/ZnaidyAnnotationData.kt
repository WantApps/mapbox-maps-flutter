package com.mapbox.maps.mapbox_maps.annotation.znaidy

import com.mapbox.geojson.Point

data class ZnaidyAnnotationData(
  val id: String,
  val geometry: Point,
  val markerType: ZnaidyMarkerType,
  val onlineStatus: ZnaidyOnlineStatus,
  val avatarUrls: List<String>,
  val stickersCount: Int,
  val companySize: Int,
  val currentSpeed: Int,
  val focused: Boolean = false,
) {
  var userAvatar = avatarUrls.firstOrNull()
}

enum class ZnaidyOnlineStatus {
  ONLINE,
  INAPP,
  OFFLINE
}

enum class ZnaidyMarkerType {
  SELF,
  FRIEND,
  COMPANY
}

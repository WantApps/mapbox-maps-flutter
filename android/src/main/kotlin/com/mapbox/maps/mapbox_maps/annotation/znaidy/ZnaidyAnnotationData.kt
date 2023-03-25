package com.mapbox.maps.mapbox_maps.annotation.znaidy

import com.mapbox.geojson.Point
import kotlin.math.max

data class ZnaidyAnnotationData(
  val id: String,
  val userId: String,
  val geometry: Point,
  val markerType: ZnaidyMarkerType,
  val onlineStatus: ZnaidyOnlineStatus,
  val avatarUrls: List<String>,
  val stickersCount: Int,
  val companySize: Int,
  val currentSpeed: Int,
  val batteryLevel: Int,
  val batteryCharging: Boolean,
  val focused: Boolean = false,
) {
  var userAvatar = avatarUrls.firstOrNull()

  companion object {
    val zoomSteps = listOf(0.0, 0.5, 0.8, 1.0, 1.2)
  }

  fun applyZoomFactor(globalZoomFactor: Double): Double {
    var factor = if (focused) {
      1.2
    } else if (markerType != ZnaidyMarkerType.SELF) {
      globalZoomFactor
    } else {
      max(0.5, globalZoomFactor)
    }
    if (onlineStatus == ZnaidyOnlineStatus.OFFLINE) {
      factor = zoomSteps[max(zoomSteps.indexOf(factor) - 1, 0)]
    }
    return factor
  }
}

enum class ZnaidyOnlineStatus {
  NONE,
  ONLINE,
  INAPP,
  OFFLINE
}

enum class ZnaidyMarkerType {
  NONE,
  SELF,
  FRIEND,
  COMPANY
}

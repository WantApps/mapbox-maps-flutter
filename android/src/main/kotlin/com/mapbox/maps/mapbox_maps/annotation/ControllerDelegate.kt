package com.mapbox.maps.mapbox_maps.annotation

import android.content.Context
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.AnimationController
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationManager
import com.mapbox.maps.viewannotation.ViewAnnotationManager

interface ControllerDelegate {
  fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *>
  fun getViewAnnotationManager(): ViewAnnotationManager
  fun getPointAnnotationManager(): PointAnnotationManager
  fun getContext(): Context
  fun getMapboxMap(): MapboxMap
  fun getCameraAnimationController(): AnimationController
}
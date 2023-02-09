package com.mapbox.maps.mapbox_maps.annotation

import android.content.Context
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.viewannotation.ViewAnnotationManager

interface ControllerDelegate {
  fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *>
  fun getViewAnnotationManager(): ViewAnnotationManager
  fun getContext(): Context
}
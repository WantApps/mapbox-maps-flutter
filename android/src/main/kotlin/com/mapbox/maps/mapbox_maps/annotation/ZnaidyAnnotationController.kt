package com.mapbox.maps.mapbox_maps.annotation

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import com.mapbox.maps.ViewAnnotationAnchor
import com.mapbox.maps.ViewAnnotationOptions
import com.mapbox.maps.mapbox_maps.R
import com.mapbox.maps.mapbox_maps.annotation.znaidy.ZnaidyAnnotationView
import com.mapbox.maps.mapbox_maps.toGeometry
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager

class ZnaidyAnnotationController(private val delegate: ControllerDelegate)
  : FLTZnaidyAnnotationMessager._ZnaidyAnnotationMessager {

  private val annotations = mutableMapOf<String, ZnaidyAnnotationView>()

  override fun create(managerId: String, annotationOptions: FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions, result: FLTZnaidyAnnotationMessager.Result<FLTZnaidyAnnotationMessager.ZnaidyAnnotation>?) {
    try {
      val viewAnnotationManager = delegate.getViewAnnotationManager()
      val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
        geometry(annotationOptions.geometry!!.toGeometry())
        width(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_size))
        height(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_size))
        anchor(ViewAnnotationAnchor.BOTTOM)
      }.build()
      val viewAnnotation = viewAnnotationManager.addViewAnnotation(R.layout.znaidy_annotation_base, viewAnnotationOptions) as ZnaidyAnnotationView
      val id = "1"
      annotations[id] = viewAnnotation
      val annotation = FLTZnaidyAnnotationMessager.ZnaidyAnnotation.Builder().apply {
        setId(id)
        setGeometry(annotationOptions.geometry)
      }.build()
      result?.success(annotation)
    } catch (ex: Exception) {
      result?.error(ex)
    }
  }

  override fun update(managerId: String, annotation: FLTZnaidyAnnotationMessager.ZnaidyAnnotation, result: FLTZnaidyAnnotationMessager.Result<Void>?) {
    try {
      annotations[annotation.id]?.let {
        val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
          geometry(annotation.geometry!!.toGeometry())
        }.build()
        val viewAnnotationManager = delegate.getViewAnnotationManager()
        viewAnnotationManager.updateViewAnnotation(it, viewAnnotationOptions)
      }
      result?.success(null)
    } catch (ex: Exception) {
      result?.error(ex)
    }
  }

  override fun delete(managetId: String, annotation: FLTZnaidyAnnotationMessager.ZnaidyAnnotation, result: FLTZnaidyAnnotationMessager.Result<Void>?) {
    try {
      annotations[annotation.id]?.let {
        val viewAnnotationManager = delegate.getViewAnnotationManager()
        viewAnnotationManager.removeViewAnnotation(it)
        annotations.remove(annotation.id)
      }
      result?.success(null)
    } catch (ex: Exception) {
      result?.error(ex)
    }
  }


}
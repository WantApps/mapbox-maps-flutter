package com.mapbox.maps.mapbox_maps.annotation

import android.util.Log
import com.mapbox.maps.ViewAnnotationAnchor
import com.mapbox.maps.ViewAnnotationOptions
import com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor
import com.mapbox.maps.mapbox_maps.R
import com.mapbox.maps.mapbox_maps.annotation.znaidy.ZnaidyAnnotationDataMapper
import com.mapbox.maps.mapbox_maps.annotation.znaidy.ZnaidyAnnotationView
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions
import com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener
import com.mapbox.maps.plugin.annotation.generated.PointAnnotation
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions

class ZnaidyAnnotationController(private val delegate: ControllerDelegate) :
  FLTZnaidyAnnotationMessager._ZnaidyAnnotationMessager, OnPointAnnotationClickListener {

  private companion object {
    const val TAG = "ZnaidyAnnotationController"
  }

  var flutterClickCallback: FLTZnaidyAnnotationMessager.OnZnaidyAnnotationClickListener? = null

  private val viewAnnotations = mutableMapOf<String, ZnaidyAnnotationView>()

  override fun create(
    managerId: String,
    annotationOptions: ZnaidyAnnotationOptions,
    result: FLTZnaidyAnnotationMessager.Result<String>?
  ) {
    if (annotationOptions.geometry == null) {
      result?.error(IllegalArgumentException("Coordinate is required to create annotation"))
    }
    try {
      val viewAnnotationManager = delegate.getViewAnnotationManager()
      val pointAnnotationManager = delegate.getPointAnnotationManager()

      val point = ZnaidyAnnotationDataMapper.geometryFromOptions(annotationOptions)

      val pointAnnotation = pointAnnotationManager.create(
        PointAnnotationOptions()
          .withPoint(point)
          .withIconImage("dot-11")
          .withIconOpacity(0.01)
          .withIconAnchor(IconAnchor.BOTTOM)
          .withIconOffset(listOf(0.0, -1.0))
          .withIconSize(10.0)
      )

      val annotationData = ZnaidyAnnotationDataMapper.createAnnotation(
        pointAnnotation.id.toString(),
        annotationOptions
      )
      val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
        geometry(annotationData.geometry)
        width(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_size))
        height(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_size))
        anchor(ViewAnnotationAnchor.BOTTOM)
        this.offsetY(-25)
        associatedFeatureId(pointAnnotation.featureIdentifier)
      }.build()
      val annotationView = viewAnnotationManager.addViewAnnotation(
        R.layout.znaidy_annotation_base,
        viewAnnotationOptions
      ) as ZnaidyAnnotationView
      annotationView.bind(annotationData)
      viewAnnotations[annotationData.id] = annotationView
      Log.d(TAG, "create: view=$annotationData, point=$pointAnnotation")
      result?.success(annotationData.id)
    } catch (ex: Exception) {
      Log.e(TAG, "create: ", ex)
      result?.error(ex)
    }
  }

  override fun update(
    managerId: String,
    annotationId: String,
    annotationOptions: ZnaidyAnnotationOptions,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    try {
      viewAnnotations[annotationId]?.let { znaidyAnnotationView ->
        Log.d(TAG, "update: $annotationOptions")
        val newAnnotationData =
          ZnaidyAnnotationDataMapper.updateAnnotation(
            znaidyAnnotationView.annotationData!!,
            annotationOptions
          )
        if (newAnnotationData.geometry != znaidyAnnotationView.annotationData!!.geometry) {
          val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
            geometry(newAnnotationData.geometry)
          }.build()
          val viewAnnotationManager = delegate.getViewAnnotationManager()
          viewAnnotationManager.updateViewAnnotation(znaidyAnnotationView, viewAnnotationOptions)
          val pointAnnotationManager = delegate.getPointAnnotationManager()
          val pointAnnotation =
            pointAnnotationManager.annotations.first { it.id.toString() == znaidyAnnotationView.annotationData!!.id }
          pointAnnotation.geometry = newAnnotationData.geometry
          pointAnnotationManager.update(pointAnnotation)
        }
        znaidyAnnotationView.bind(newAnnotationData)
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
      result?.success(null)
    } catch (ex: Exception) {
      Log.e(TAG, "update: ", ex)
      result?.error(ex)
    }
  }

  override fun delete(
    managetId: String,
    annotationId: String,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    try {
      viewAnnotations[annotationId]?.let { znaidyAnnotationView ->
        val viewAnnotationManager = delegate.getViewAnnotationManager()
        viewAnnotationManager.removeViewAnnotation(znaidyAnnotationView)
        val pointAnnotationManager = delegate.getPointAnnotationManager()
        val pointAnnotation =
          pointAnnotationManager.annotations.first { it.id.toString() == znaidyAnnotationView.annotationData!!.id }
        pointAnnotationManager.delete(pointAnnotation)
        viewAnnotations.remove(annotationId)
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
      result?.success(null)
    } catch (ex: Exception) {
      Log.e(TAG, "delete: ", ex)
      result?.error(ex)
    }
  }

  override fun onAnnotationClick(annotation: PointAnnotation): Boolean {
    Log.d(TAG, "onAnnotationClick: $annotation")
    viewAnnotations[annotation.id.toString()]?.annotationData?.let { annotationData ->
      Log.d(TAG, "onAnnotationClick: $annotationData")
      flutterClickCallback?.onZnaidyAnnotationClick(
        annotationData.id,
        ZnaidyAnnotationDataMapper.mapToOptions(annotationData)
      ) {
        Log.d(TAG, "onAnnotationClick: ${annotationData.id} finished")
      }
    }
    return true
  }

}
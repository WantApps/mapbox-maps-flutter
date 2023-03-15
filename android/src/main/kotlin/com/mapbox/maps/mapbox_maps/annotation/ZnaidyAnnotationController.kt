package com.mapbox.maps.mapbox_maps.annotation

import android.util.Log
import com.mapbox.geojson.Point
import com.mapbox.maps.ViewAnnotationAnchor
import com.mapbox.maps.ViewAnnotationOptions
import com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor
import com.mapbox.maps.mapbox_maps.R
import com.mapbox.maps.mapbox_maps.annotation.znaidy.*
import com.mapbox.maps.mapbox_maps.toMap
import com.mapbox.maps.pigeons.FLTMapInterfaces.CameraOptions
import com.mapbox.maps.pigeons.FLTMapInterfaces.MapAnimationOptions
import com.mapbox.maps.pigeons.FLTMapInterfaces.MbxEdgeInsets
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions
import com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener
import com.mapbox.maps.plugin.annotation.generated.PointAnnotation
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions
import java.util.*

class ZnaidyAnnotationController(private val delegate: ControllerDelegate) :
  FLTZnaidyAnnotationMessager._ZnaidyAnnotationMessager, OnPointAnnotationClickListener,
  OnPositionAnimationListener {

  private companion object {
    const val TAG = "ZnaidyAnnotationController"
  }

  var flutterClickCallback: FLTZnaidyAnnotationMessager.OnZnaidyAnnotationClickListener? = null


  private var updateRate: Long = 2000L
  private val viewAnnotations = mutableMapOf<String, ZnaidyAnnotationView>()
  private val annotationAnimations = mutableMapOf<String, ZnaidyPositionAnimator>()

  private var trackingCameraOptionsBuilder: CameraOptions.Builder? = null

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
          .withIconOpacity(0.00)
          .withIconAnchor(IconAnchor.BOTTOM)
          .withIconOffset(listOf(0.0, 0.0))
          .withIconSize(5.0)
      )

      val annotationData = ZnaidyAnnotationDataMapper.createAnnotation(
        pointAnnotation.id.toString(),
        annotationOptions
      )
      val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
        geometry(annotationData.geometry)
        width(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_width_focused))
        height(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_height_focused))
        anchor(ViewAnnotationAnchor.BOTTOM)
        offsetY(-delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_y_offset))
        associatedFeatureId(pointAnnotation.featureIdentifier)
        allowOverlap(true)
        selected(annotationData.markerType == ZnaidyMarkerType.SELF)
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
        if (newAnnotationData.zoomFactor <= 0.5) {
          val viewAnnotationManager = delegate.getViewAnnotationManager()
          val viewAnnotationOptionsBuilder = ViewAnnotationOptions.Builder()
          if (newAnnotationData.geometry != znaidyAnnotationView.annotationData!!.geometry) {
            val pointAnnotationManager = delegate.getPointAnnotationManager()
            viewAnnotationOptionsBuilder.geometry(newAnnotationData.geometry)
            val pointAnnotation =
              pointAnnotationManager.annotations.first { it.id.toString() == znaidyAnnotationView.annotationData!!.id }
            pointAnnotation.geometry = newAnnotationData.geometry
            pointAnnotationManager.update(pointAnnotation)
          }
          val isHidden = newAnnotationData.zoomFactor == 0.0 && newAnnotationData.markerType != ZnaidyMarkerType.SELF
          if (isHidden) {
            znaidyAnnotationView.delete {
              val viewAnnotationOptionsBuilder = ViewAnnotationOptions.Builder()
              viewAnnotationOptionsBuilder.visible(false)
              viewAnnotationManager.updateViewAnnotation(znaidyAnnotationView, viewAnnotationOptionsBuilder.build())
            }
          } else {
            viewAnnotationOptionsBuilder.visible(true)
          }
          viewAnnotationManager.updateViewAnnotation(znaidyAnnotationView, viewAnnotationOptionsBuilder.build())
        } else {
          if (newAnnotationData.geometry != znaidyAnnotationView.annotationData!!.geometry) {
            val startPosition = annotationAnimations[annotationId]?.let {
              annotationAnimations.remove(annotationId)
              it.stop()
            } ?: znaidyAnnotationView.annotationData!!.geometry
            val animator = ZnaidyPositionAnimator(
              annotationId,
              startPosition,
              newAnnotationData.geometry,
              updateRate,
              this
            ).apply { start() }
            annotationAnimations[annotationId] = animator
          }
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
    managerId: String,
    annotationId: String,
    animated: Boolean,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    try {
      viewAnnotations[annotationId]?.let { znaidyAnnotationView ->
        if (animated) {
          znaidyAnnotationView.delete {
            deleteAnnotation(annotationId, znaidyAnnotationView)
          }
        } else {
          deleteAnnotation(annotationId, znaidyAnnotationView)
        }
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
      result?.success(null)
    } catch (ex: Exception) {
      Log.e(TAG, "delete: ", ex)
      result?.error(ex)
    }
  }

  private fun deleteAnnotation(annotationId: String, znaidyAnnotationView: ZnaidyAnnotationView) {
    val viewAnnotationManager = delegate.getViewAnnotationManager()
    viewAnnotationManager.removeViewAnnotation(znaidyAnnotationView)
    val pointAnnotationManager = delegate.getPointAnnotationManager()
    val pointAnnotation =
      pointAnnotationManager.annotations.first { it.id.toString() == znaidyAnnotationView.annotationData!!.id }
    pointAnnotationManager.delete(pointAnnotation)
    viewAnnotations.remove(annotationId)
  }

  override fun select(
    managerId: String,
    annotationId: String,
    bottomPadding: Double,
    animationDuration: Long,
    zoom: Double,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    try {
      viewAnnotations[annotationId]?.let { znaidyAnnotationView ->
        val newAnnotationData = znaidyAnnotationView.annotationData?.copy(focused = true)
        newAnnotationData?.let { annotationData ->
          znaidyAnnotationView.bind(annotationData)
          val padding = MbxEdgeInsets.Builder().apply {
            setBottom(bottomPadding)
            setTop(0.0)
            setLeft(0.0)
            setRight(0.0)
          }.build()
          trackingCameraOptionsBuilder = CameraOptions.Builder().apply {
            setCenter(annotationData.geometry.toMap())
            setBearing(0.0)
            setZoom(zoom)
            setPadding(padding)
          }
          val cameraOptions = trackingCameraOptionsBuilder!!.build()
          val animationOptions = MapAnimationOptions.Builder().apply {
            setDuration(animationDuration)
          }.build()
          delegate.getCameraAnimationController().flyTo(
            cameraOptions,
            animationOptions
          )
        }
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
    } catch (ex: Exception) {
      Log.e(TAG, "select: ", ex)
      result?.error(ex)
    }
  }

  override fun resetSelection(
    managerId: String,
    annotationId: String,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    try {
      viewAnnotations[annotationId]?.let { znaidyAnnotationView ->
        Log.d(TAG, "resetSelection: annotationData.focused=${znaidyAnnotationView.annotationData?.focused}")
        znaidyAnnotationView.annotationData?.let { annotationData ->
          val newAnnotationData = annotationData.copy(focused = false)
          znaidyAnnotationView.bind(newAnnotationData)
        }
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
    } catch (ex: Exception) {
      Log.e(TAG, "resetSelection: ", ex)
      result?.error(ex)
    }
  }

  override fun sendSticker(
    managerId: String,
    annotationId: String,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    try {
      viewAnnotations[annotationId]?.let { znaidyAnnotationView ->
        znaidyAnnotationView.animateReceiveSticker()
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
    } catch (ex: Exception) {
      Log.e(TAG, "sendSticker: ", ex)
      result?.error(ex)
    }
  }

  override fun setUpdateRate(
    managerId: String,
    rate: Long,
    result: FLTZnaidyAnnotationMessager.Result<Void>?
  ) {
    updateRate = rate
    result?.success(null)
  }

  override fun onAnnotationClick(annotation: PointAnnotation): Boolean {
    Log.d(TAG, "onAnnotationClick: $annotation")
    viewAnnotations[annotation.id.toString()]?.annotationData?.let { annotationData ->
      Log.d(TAG, "onAnnotationClick: $annotationData")
      if (annotationData.zoomFactor < 0.5 && annotationData.markerType != ZnaidyMarkerType.SELF) return true;
      flutterClickCallback?.onZnaidyAnnotationClick(
        annotationData.id,
        ZnaidyAnnotationDataMapper.mapToOptions(annotationData)
      ) {
        Log.d(TAG, "onAnnotationClick: ${annotationData.id} finished")
      }
    }
    return true
  }

  override fun onPositionAnimationUpdate(id: String, position: Point) {
    try {
      viewAnnotations[id]?.let { znaidyAnnotationView ->
        val viewAnnotationManager = delegate.getViewAnnotationManager()
        val pointAnnotationManager = delegate.getPointAnnotationManager()
        val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
          geometry(position)
        }.build()
        viewAnnotationManager.updateViewAnnotation(znaidyAnnotationView, viewAnnotationOptions)
        val pointAnnotation =
          pointAnnotationManager.annotations.first { it.id.toString() == znaidyAnnotationView.annotationData!!.id }
        pointAnnotation.geometry = position
        pointAnnotationManager.update(pointAnnotation)
        Log.d(TAG, "onAnimationUpdate: focused=${znaidyAnnotationView.annotationData?.focused}")
        if (znaidyAnnotationView.annotationData?.focused != true) return
        trackingCameraOptionsBuilder?.let { cameraOptionsBuilder ->
          cameraOptionsBuilder.setCenter(position.toMap())
          val cameraOptions = cameraOptionsBuilder.build()
          val animationOptions = MapAnimationOptions.Builder().apply { setDuration(0) }.build()
          delegate.getCameraAnimationController().flyTo(cameraOptions, animationOptions)
        }
      }
    } catch (ex: Exception) {
      Log.e(TAG, "onPositionAnimationUpdate: ", ex)
      annotationAnimations[id]?.stop()
      annotationAnimations.remove(id)
    }
  }

  override fun onPositionAnimationEnded(id: String) {
    annotationAnimations.remove(id)
  }
}
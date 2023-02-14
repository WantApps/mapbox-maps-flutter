package com.mapbox.maps.mapbox_maps.annotation

import android.content.Context
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.*
import com.mapbox.maps.plugin.annotation.AnnotationManager
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.*
import com.mapbox.maps.viewannotation.ViewAnnotationManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AnnotationController(private val mapView: MapView, private val mapboxMap: MapboxMap) :
  ControllerDelegate {

  companion object {
    const val ZNAIDY_ANNOTATION_CONTROLLER_ID = "0"
    const val ZNAIDY_POINT_CONTROLLER_ID = "1"
  }
  private val managerMap = mutableMapOf<String, AnnotationManager<*, *, *, *, *, *, *>>()
  private val pointAnnotationController = PointAnnotationController(this)
  private val circleAnnotationController = CircleAnnotationController(this)
  private val polygonAnnotationController = PolygonAnnotationController(this)
  private val polylineAnnotationController = PolylineAnnotationController(this)
  private val znaidyAnnotationController = ZnaidyAnnotationController(this)
  private lateinit var onPointAnnotationClickListener: FLTPointAnnotationMessager.OnPointAnnotationClickListener
  private lateinit var onPolygonAnnotationClickListener: FLTPolygonAnnotationMessager.OnPolygonAnnotationClickListener
  private lateinit var onPolylineAnnotationController: FLTPolylineAnnotationMessager.OnPolylineAnnotationClickListener
  private lateinit var onCircleAnnotationClickListener: FLTCircleAnnotationMessager.OnCircleAnnotationClickListener
  private lateinit var onZnaidyAnnotationClickListener: FLTZnaidyAnnotationMessager.OnZnaidyAnnotationClickListener
  private var index = 2
  fun handleCreateManager(call: MethodCall, result: MethodChannel.Result) {
    val manager = when (val type = call.argument<String>("type")!!) {
      "circle" -> {
        mapView.annotations.createCircleAnnotationManager().apply {
          this.addClickListener(
            OnCircleAnnotationClickListener { annotation ->
              onCircleAnnotationClickListener.onCircleAnnotationClick(annotation.toFLTCircleAnnotation()) {}
              true
            }
          )
        }
      }
      "point" -> {
        mapView.annotations.createPointAnnotationManager().apply {
          this.addClickListener(
            OnPointAnnotationClickListener { annotation ->
              onPointAnnotationClickListener.onPointAnnotationClick(annotation.toFLTPointAnnotation()) {}
              true
            }
          )
        }
      }
      "polygon" -> {
        mapView.annotations.createPolygonAnnotationManager().apply {
          this.addClickListener(
            OnPolygonAnnotationClickListener { annotation ->
              onPolygonAnnotationClickListener.onPolygonAnnotationClick(annotation.toFLTPolygonAnnotation()) {}
              true
            }
          )
        }
      }
      "polyline" -> {
        mapView.annotations.createPolylineAnnotationManager().apply {
          this.addClickListener(
            OnPolylineAnnotationClickListener { annotation ->
              onPolylineAnnotationController.onPolylineAnnotationClick(annotation.toFLTPolylineAnnotation()) {}
              true
            }
          )
        }
      }
      "znaidy" -> {
        val pointManager = mapView.annotations.createPointAnnotationManager().apply {
          this.addClickListener(znaidyAnnotationController)
        }
        managerMap[ZNAIDY_POINT_CONTROLLER_ID] = pointManager
        result.success(ZNAIDY_ANNOTATION_CONTROLLER_ID)
        return
      }
      else -> {
        result.error("0", "Unrecognized manager type: $type", null)
        return
      }
    }
    val id = (index++).toString()
    managerMap[id] = manager
    result.success(id)
  }

  fun handleRemoveManager(call: MethodCall, result: MethodChannel.Result) {
    val id = call.argument<String>("id")!!
    if (id == ZNAIDY_ANNOTATION_CONTROLLER_ID) {
      managerMap.remove(ZNAIDY_POINT_CONTROLLER_ID)?.let {
        mapView.annotations.removeAnnotationManager(it)
      }
      result.success(null)
    }
    managerMap.remove(id)?.let {
      mapView.annotations.removeAnnotationManager(it)
    }
    result.success(null)
  }

  fun setup(messenger: BinaryMessenger) {
    onPointAnnotationClickListener = FLTPointAnnotationMessager.OnPointAnnotationClickListener(messenger)
    onCircleAnnotationClickListener = FLTCircleAnnotationMessager.OnCircleAnnotationClickListener(messenger)
    onPolygonAnnotationClickListener = FLTPolygonAnnotationMessager.OnPolygonAnnotationClickListener(messenger)
    onPolylineAnnotationController = FLTPolylineAnnotationMessager.OnPolylineAnnotationClickListener(messenger)
    onZnaidyAnnotationClickListener = FLTZnaidyAnnotationMessager.OnZnaidyAnnotationClickListener(messenger)
    FLTPointAnnotationMessager._PointAnnotationMessager.setup(messenger, pointAnnotationController)
    FLTCircleAnnotationMessager._CircleAnnotationMessager.setup(
      messenger,
      circleAnnotationController
    )
    FLTPolylineAnnotationMessager._PolylineAnnotationMessager.setup(
      messenger,
      polylineAnnotationController
    )
    FLTPolygonAnnotationMessager._PolygonAnnotationMessager.setup(
      messenger,
      polygonAnnotationController
    )
    FLTZnaidyAnnotationMessager._ZnaidyAnnotationMessager.setup(
      messenger,
      znaidyAnnotationController
    )
    znaidyAnnotationController.flutterClickCallback = onZnaidyAnnotationClickListener
  }

  fun dispose(messenger: BinaryMessenger) {
    FLTPointAnnotationMessager._PointAnnotationMessager.setup(messenger, null)
    FLTCircleAnnotationMessager._CircleAnnotationMessager.setup(messenger, null)
    FLTPolylineAnnotationMessager._PolylineAnnotationMessager.setup(messenger, null)
    FLTPolygonAnnotationMessager._PolygonAnnotationMessager.setup(messenger, null)
    FLTZnaidyAnnotationMessager._ZnaidyAnnotationMessager.setup(messenger, null)
  }

  override fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *> {
    if (managerMap[managerId] == null) {
      throw(Throwable("No manager found with id: $managerId"))
    }
    return managerMap[managerId]!!
  }

  override fun getViewAnnotationManager(): ViewAnnotationManager {
    return mapView.viewAnnotationManager
  }

  override fun getPointAnnotationManager(): PointAnnotationManager {
    return getManager(ZNAIDY_POINT_CONTROLLER_ID) as PointAnnotationManager
  }

  override fun getContext(): Context {
    return mapView.context
  }
}
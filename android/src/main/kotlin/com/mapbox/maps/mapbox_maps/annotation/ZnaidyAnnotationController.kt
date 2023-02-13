package com.mapbox.maps.mapbox_maps.annotation

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Log
import android.view.View
import androidx.annotation.DrawableRes
import com.mapbox.maps.ViewAnnotationAnchor
import com.mapbox.maps.ViewAnnotationOptions
import com.mapbox.maps.mapbox_maps.R
import com.mapbox.maps.mapbox_maps.annotation.znaidy.ZnaidyAnnotationDataMapper
import com.mapbox.maps.mapbox_maps.annotation.znaidy.ZnaidyAnnotationTuple
import com.mapbox.maps.mapbox_maps.annotation.znaidy.ZnaidyAnnotationView
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager
import com.mapbox.maps.pigeons.FLTZnaidyAnnotationMessager.ZnaidyAnnotationOptions
import com.mapbox.maps.plugin.annotation.AnnotationOptions
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions

class ZnaidyAnnotationController(private val delegate: ControllerDelegate)
  : FLTZnaidyAnnotationMessager._ZnaidyAnnotationMessager, View.OnClickListener {

  private companion object {
    const val TAG = "ZnaidyAnnotationController"
  }

  var flutterClickCallback: FLTZnaidyAnnotationMessager.OnZnaidyAnnotationClickListener? = null

  private val annotations = mutableMapOf<String, ZnaidyAnnotationView>()

  override fun create(managerId: String, annotationOptions: ZnaidyAnnotationOptions, result: FLTZnaidyAnnotationMessager.Result<String>?) {
    if (annotationOptions.geometry == null) {
      result?.error(IllegalArgumentException("Coordinate is required to create annotation"))
    }
    try {
      val viewAnnotationManager = delegate.getViewAnnotationManager()
      val annotationData = ZnaidyAnnotationDataMapper.createAnnotation(getNextId(), annotationOptions)
//      val pointAnnotationManager = delegate.getManager("1") as PointAnnotationManager
//
//      val pointAnnotation = pointAnnotationManager.create(
//        PointAnnotationOptions()
//          .withPoint(annotationData.geometry)
//          .withIconImage(bitmapFromDrawableRes(delegate.getContext(), R.drawable.red_marker)!!)
//          .withIconSize(0.0)
//      )
//
//
//      Log.d(TAG, "create: pointAnnitation=$pointAnnotation")
//
      val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
        geometry(annotationData.geometry)
        width(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_size))
        height(delegate.getContext().resources.getDimensionPixelOffset(R.dimen.annotation_size))
        anchor(ViewAnnotationAnchor.BOTTOM)
//        associatedFeatureId(pointAnnotation.featureIdentifier)
      }.build()
      val annotationView = viewAnnotationManager.addViewAnnotation(R.layout.znaidy_annotation_base, viewAnnotationOptions) as ZnaidyAnnotationView
      annotationView.bind(annotationData)
      annotationView.setOnTapListener(this)
      annotations[annotationData.id] = annotationView
      result?.success(annotationData.id)
    } catch (ex: Exception) {
      Log.e(TAG, "create: ", ex)
      result?.error(ex)
    }
  }

  override fun update(managerId: String, annotationId: String, annotationOptions: ZnaidyAnnotationOptions, result: FLTZnaidyAnnotationMessager.Result<Void>?) {
    try {
      annotations[annotationId]?.let {
        Log.d(TAG, "update: $annotationOptions")
        val newAnnotationData = ZnaidyAnnotationDataMapper.updateAnnotation(it.annotationData!!, annotationOptions)
        val viewAnnotationOptions = ViewAnnotationOptions.Builder().apply {
          if (newAnnotationData.geometry != it.annotationData!!.geometry) geometry(newAnnotationData.geometry)
        }.build()
        val viewAnnotationManager = delegate.getViewAnnotationManager()
        viewAnnotationManager.updateViewAnnotation(it, viewAnnotationOptions)
        it.bind(newAnnotationData)
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
      result?.success(null)
    } catch (ex: Exception) {
      Log.e(TAG, "update: ", ex)
      result?.error(ex)
    }
  }

  override fun delete(managetId: String, annotationId: String, result: FLTZnaidyAnnotationMessager.Result<Void>?) {
    try {
      annotations[annotationId]?.let {
        val viewAnnotationManager = delegate.getViewAnnotationManager()
        viewAnnotationManager.removeViewAnnotation(it)
        annotations.remove(annotationId)
      } ?: result?.error(IllegalArgumentException("Annotation with id [$annotationId] not found"))
      result?.success(null)
    } catch (ex: Exception) {
      Log.e(TAG, "delete: ", ex)
      result?.error(ex)
    }
  }

  private fun getNextId(): String {
    return "1"
  }

  override fun onClick(v: View?) {
    Log.d(TAG, "onClick: view=$v, callback=$flutterClickCallback")
    (v as ZnaidyAnnotationView).let { annotationView ->
      annotationView.annotationData?.let { annotationData ->
        Log.d(TAG, "onClick: $annotationData")
        flutterClickCallback?.onZnaidyAnnotationClick(
          annotationData.id,
          null
        ) {
          Log.d(TAG, "onClick: finished")
        }
      }
    }
  }

  private fun bitmapFromDrawableRes(context: Context, @DrawableRes resourceId: Int) =
    convertDrawableToBitmap(context.resources.getDrawable(R.drawable.red_marker, null))

  private fun convertDrawableToBitmap(sourceDrawable: Drawable?): Bitmap? {
    if (sourceDrawable == null) {
      return null
    }
    return if (sourceDrawable is BitmapDrawable) {
      sourceDrawable.bitmap
    } else {
// copying drawable object to not manipulate on the same reference
      val constantState = sourceDrawable.constantState ?: return null
      val drawable = constantState.newDrawable().mutate()
      val bitmap: Bitmap = Bitmap.createBitmap(
        drawable.intrinsicWidth, drawable.intrinsicHeight,
        Bitmap.Config.ARGB_8888
      )
      val canvas = Canvas(bitmap)
      drawable.setBounds(0, 0, canvas.width, canvas.height)
      drawable.draw(canvas)
      bitmap
    }
  }

}
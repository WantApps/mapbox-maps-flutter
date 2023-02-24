package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.animation.Animator
import android.animation.ObjectAnimator
import android.animation.TimeInterpolator
import android.animation.TypeEvaluator
import android.animation.ValueAnimator
import android.util.Log
import android.view.animation.LinearInterpolator
import com.mapbox.geojson.Point

interface OnPositionAnimationListener {
  fun onPositionAnimationUpdate(id: String, position: Point)
  fun onPositionAnimationEnded(id: String)
}

class ZnaidyPositionAnimator(
  val id: String,
  startPosition: Point,
  endPosition: Point,
  duration: Long,
  private val listener: OnPositionAnimationListener,
) : ValueAnimator.AnimatorUpdateListener, Animator.AnimatorListener {

  companion object {
    private const val TAG = "ZnaidyPositionAnimator"
  }

  private val animator: ValueAnimator
  private val positionEvaluator = PositionEvaluator(startPosition)

  val isRunning
    get() = animator.isRunning

  init {
    animator = ObjectAnimator
      .ofObject(positionEvaluator, startPosition, endPosition)
      .setDuration(duration)
    animator.interpolator = LinearInterpolator()
    animator.addUpdateListener(this)
    animator.addListener(this)
  }

  fun start() {
    Log.v(TAG, "start: [$id]")
    animator.start()
  }

  fun stop(): Point {
    Log.v(TAG, "stop: [$id], isRunning=$isRunning")
    animator.cancel()
    return positionEvaluator.currentPosition
  }

  override fun onAnimationUpdate(animation: ValueAnimator) {
    val geometry = animation.animatedValue as Point
    listener.onPositionAnimationUpdate(id, geometry)
  }

  override fun onAnimationStart(animation: Animator?) {
  }

  override fun onAnimationEnd(animation: Animator?) {
    Log.v(TAG, "onAnimationEnd: [$id]")
    listener.onPositionAnimationEnded(id)
  }

  override fun onAnimationCancel(animation: Animator?) {
    Log.v(TAG, "onAnimationCancel: [$id]")
  }

  override fun onAnimationRepeat(animation: Animator?) {
  }

  private class PositionEvaluator(startPosition: Point) : TypeEvaluator<Point> {
    var currentPosition: Point = startPosition
      private set

    override fun evaluate(fraction: Float, startValue: Point, endValue: Point): Point {
      currentPosition = Point.fromLngLat(
        startValue.longitude() + ((endValue.longitude() - startValue.longitude()) * fraction),
        startValue.latitude() + ((endValue.latitude() - startValue.latitude()) * fraction),
      )
      return currentPosition
    }
  }
}
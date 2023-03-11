package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.DimenRes
import androidx.annotation.DrawableRes
import androidx.annotation.IdRes
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CircleCrop
import com.bumptech.glide.request.RequestOptions
import com.mapbox.maps.mapbox_maps.R
import kotlin.math.max
import kotlin.math.roundToInt


class ZnaidyAnnotationView @JvmOverloads constructor(
  context: Context, attrs: AttributeSet? = null
) : ConstraintLayout(context, attrs), View.OnAttachStateChangeListener {

  companion object {
    const val TAG = "ZnaidyAnnotationView"
  }

  var annotationData: ZnaidyAnnotationData? = null
    private set

  private val animator = ZnaidyMarkerAnimator(this)

  init {
    LayoutInflater.from(context).inflate(R.layout.znaidy_annotation, this)
    addOnAttachStateChangeListener(this)
  }

  override fun onViewAttachedToWindow(v: View?) {
    Log.d(TAG, "onViewAttachedToWindow: ")
    animator.animateCreation {
      annotationData?.let {
        if (it.zoomFactor >= 1) {
          if (it.onlineStatus != ZnaidyOnlineStatus.OFFLINE) {
            animator.startIdleAnimation()
            if (it.markerType != ZnaidyMarkerType.COMPANY) {
              animator.startGlowAnimation()
            }
          }
        } else {
          animator.stopIdleAnimation()
          animator.hideGlowAnimation()
        }
      }
    }
  }

  override fun onViewDetachedFromWindow(v: View?) {
    Log.d(TAG, "onViewDetachedFromWindow: ")
    animator.stopAllAnimations()
  }

  fun bind(annotation: ZnaidyAnnotationData) {
    Log.d(TAG, "bind: $annotation")
    val constraintAnimationBuilder = ZnaidyConstraintAnimation.Builder(this)
    if (annotation.markerType != ZnaidyMarkerType.SELF) {
      constraintAnimationBuilder.zoomFactor = annotation.zoomFactor
    } else {
      constraintAnimationBuilder.zoomFactor = max(0.5, annotation.zoomFactor)
    }
    when (annotation.markerType) {
      ZnaidyMarkerType.SELF -> bindSelf(annotation, constraintAnimationBuilder)
      ZnaidyMarkerType.FRIEND -> bindFriend(annotation, constraintAnimationBuilder)
      ZnaidyMarkerType.COMPANY -> bindCompany(annotation, constraintAnimationBuilder)
      else -> Unit
    }

    if (annotation.zoomFactor != 0.0) {
      setLayout(constraintAnimationBuilder, annotation)
      if (annotationData != null) constraintAnimationBuilder.onAnimationEnd = {
        if (annotation.zoomFactor >= 1.0) {
          animator.startIdleAnimation()
          animator.showGlowAnimation()
          if (annotation.markerType != ZnaidyMarkerType.COMPANY) {
            animator.startGlowAnimation()
          }
        } else {
          animator.stopIdleAnimation()
          animator.hideGlowAnimation()
        }
      }
    } else {
      animator.stopIdleAnimation()
      animator.hideGlowAnimation()
    }

    val animation = constraintAnimationBuilder.build()
    Log.d(TAG, "bind: constraintAnimation hasChanges=${animation.hasChanges} (${animation.changesCount})")
    if (animation.hasChanges) animation.run()
    annotationData = annotation
  }

  fun animateReceiveSticker() {
    animator.animateReceiveSticker()
  }

  fun delete(onAnimationEnd: () -> Unit) {
    animator.animateDeletion(onAnimationEnd)
  }

  private fun bindSelf(
    annotation: ZnaidyAnnotationData,
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val typeChanged = annotationData?.markerType != annotation.markerType
    if (typeChanged) {
      animator.stopAvatarAnimation()
      setMarkerBackground(R.drawable.znaidy_marker_self)
      hideStickersCount(constraintAnimationBuilder)
      hideCompanySize(constraintAnimationBuilder)
    }
    if (typeChanged || annotationData?.userAvatar != annotation.userAvatar) {
      setAvatar(annotation.userAvatar)
    }
    if (typeChanged || annotationData?.onlineStatus != annotation.onlineStatus || annotationData?.focused != annotation.focused) {
      setOnlineStatus(annotation.onlineStatus)
    }
    if (typeChanged || annotationData?.currentSpeed != annotation.currentSpeed) {
      setCurrentSpeed(annotation.currentSpeed)
    }
  }


  private fun bindFriend(
    annotation: ZnaidyAnnotationData,
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val typeChanged = annotationData?.markerType != annotation.markerType
    if (typeChanged) {
      animator.stopAvatarAnimation()
      setMarkerBackground(R.drawable.znaidy_marker_friend)
      hideCompanySize(constraintAnimationBuilder)
    }
    if (typeChanged || annotationData?.userAvatar != annotation.userAvatar) {
      setAvatar(annotation.userAvatar)
    }
    if (typeChanged || annotationData?.onlineStatus != annotation.onlineStatus || annotationData?.focused != annotation.focused) {
      setOnlineStatus(annotation.onlineStatus)
    }
    if (typeChanged || annotationData?.stickersCount != annotation.stickersCount) {
      setStickersCount(annotation.stickersCount, constraintAnimationBuilder)
    }
    if (typeChanged || annotationData?.currentSpeed != annotation.currentSpeed) {
      setCurrentSpeed(annotation.currentSpeed)
    }
  }

  private fun bindCompany(
    annotation: ZnaidyAnnotationData,
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val typeChanged = annotationData?.markerType != annotation.markerType
    if (typeChanged) {
      setMarkerBackground(R.drawable.znaidy_marker_company)
      showCompanyGlow()
      hideStickersCount(constraintAnimationBuilder)
    }
    if (typeChanged || annotationData?.avatarUrls != annotation.avatarUrls) {
      setCompanyAvatars(annotation.avatarUrls)
    }
    if (typeChanged || annotationData?.companySize != annotation.companySize) {
      setCompanySize(annotation.companySize, constraintAnimationBuilder)
    }
  }

  private fun setMarkerBackground(@DrawableRes drawable: Int) {
    val background = findViewById<ImageView>(R.id.markerBackground)
    background.setImageResource(drawable)
  }

  private fun setOnlineStatus(onlineStatus: ZnaidyOnlineStatus) {
    val markerGlow = findViewById<View>(R.id.glow)
    when (onlineStatus) {
      ZnaidyOnlineStatus.ONLINE -> {
        markerGlow.setBackgroundResource(R.drawable.marker_glow_online)
        animator.startGlowAnimation()
      }
      ZnaidyOnlineStatus.INAPP -> {
        markerGlow.setBackgroundResource(R.drawable.marker_glow_inapp)
        animator.startGlowAnimation()
      }
      ZnaidyOnlineStatus.OFFLINE -> {
        markerGlow.setBackgroundResource(0)
        animator.stopGlowAnimation()
      }
    }
  }

  private fun showInApp(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.inApp, View.VISIBLE, constraintAnimationBuilder)
  }

  private fun hideInApp(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.inApp, View.GONE, constraintAnimationBuilder)
  }

  private fun setLayout(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder, annotationData: ZnaidyAnnotationData) {
    constraintAnimationBuilder.addChange { constraintSet ->
      constraintSet.constrainWidth(R.id.markerBackground, getDimen(R.dimen.marker_width, constraintAnimationBuilder.zoomFactor))
      constraintSet.constrainHeight(R.id.markerBackground, getDimen(R.dimen.marker_height, constraintAnimationBuilder.zoomFactor))

      constraintSet.constrainWidth(R.id.avatar, getDimen(R.dimen.avatar_size, constraintAnimationBuilder.zoomFactor))
      constraintSet.constrainHeight(R.id.avatar, getDimen(R.dimen.avatar_size, constraintAnimationBuilder.zoomFactor))
      constraintSet.setMargin(R.id.avatar, ConstraintSet.BOTTOM, getDimen(R.dimen.avatar_offset, constraintAnimationBuilder.zoomFactor))

      constraintSet.setScaleX(R.id.glow, constraintAnimationBuilder.zoomFactor.toFloat())
      constraintSet.setScaleY(R.id.glow, constraintAnimationBuilder.zoomFactor.toFloat())
      val glowMargin = (getDimen(R.dimen.annotation_width_focused) - getDimen(R.dimen.annotation_width_focused, constraintAnimationBuilder.zoomFactor)) / 2
      constraintSet.setMargin(R.id.glow, ConstraintSet.BOTTOM, getDimen(R.dimen.glow_y_offset) - glowMargin)

      if (constraintAnimationBuilder.zoomFactor <= 0.5 || annotationData.currentSpeed == 0) {
        constraintSet.setVisibility(R.id.speed, View.GONE)
      } else {
        constraintSet.setVisibility(R.id.speed, View.VISIBLE)
        val speedZoomFactor = if (constraintAnimationBuilder.zoomFactor >= 1.0) 1.0 else 0.7
        constraintSet.constrainWidth(R.id.speed, getDimen(R.dimen.current_speed_width, speedZoomFactor))
        constraintSet.constrainHeight(R.id.speed, getDimen(R.dimen.current_speed_height, speedZoomFactor))
        constraintSet.setMargin(R.id.speed, ConstraintSet.BOTTOM, getDimen(R.dimen.current_speed_offset_vertical, speedZoomFactor))
        constraintSet.setMargin(R.id.speed, ConstraintSet.START, if (speedZoomFactor >= 1.0) getDimen(R.dimen.current_speed_offset_horizontal) else getDimen(R.dimen.current_speed_offset_horizontal_small))
        findViewById<TextView>(R.id.currentSpeedText).setTextSize(
          TypedValue.COMPLEX_UNIT_PX,
          (if (speedZoomFactor >= 1.0) getDimen(R.dimen.current_speed_text_number) else getDimen(R.dimen.current_speed_text_number_small)).toFloat()
        )
        findViewById<TextView>(R.id.currentSpeedUnits).setTextSize(
          TypedValue.COMPLEX_UNIT_PX,
          (if (speedZoomFactor >= 1.0) getDimen(R.dimen.current_speed_text_units) else getDimen(R.dimen.current_speed_text_units_small)).toFloat()
        )
      }
    }
  }

  private fun getDimen(@DimenRes dimen: Int, zoomFactor: Double = 1.0): Int {
    return (context.resources.getDimensionPixelOffset(dimen) * zoomFactor).roundToInt()
  }

  private fun showCompanyGlow() {
    val markerGlow = findViewById<View>(R.id.glow)
    markerGlow.setBackgroundResource(R.drawable.marker_glow_company)
    animator.startGlowAnimation()
  }

  private fun setStickersCount(
    stickersCount: Int,
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val stickerLabel = findViewById<TextView>(R.id.stickerCounterText)

    if (stickersCount == 0) {
      hideStickersCount(constraintAnimationBuilder)
    } else {
      showStickersCounter(constraintAnimationBuilder)
      stickerLabel.text = if (stickersCount <= 9) stickersCount.toString() else "9+"
    }
  }

  private fun hideStickersCount(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.stickers, View.GONE, constraintAnimationBuilder)
  }

  private fun showStickersCounter(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.stickers, View.VISIBLE, constraintAnimationBuilder)
  }

  private fun setAvatar(avatarUrl: String?) {
    val avatarView = findViewById<ImageView>(R.id.profileIcon)

    val request = if (avatarUrl != null) {
      Glide.with(this)
        .load(avatarUrl)
    } else {
      Glide.with(this)
        .load(R.drawable.avatar_placeholder)
    }
    request
      .error(R.drawable.avatar_placeholder)
      .apply(RequestOptions.bitmapTransform(CircleCrop()))
      .into(avatarView)
  }

  private fun setCompanyAvatars(avatarUrls: List<String>) {
    animator.startAvatarAnimation(avatarUrls.size) {
      setAvatar(avatarUrls[it])
    }
  }

  private fun setCompanySize(
    companySize: Int,
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val companyLabel = findViewById<TextView>(R.id.companySizeText)
    val background = findViewById<ImageView>(R.id.markerBackground)

    if (companySize == 0) {
      hideCompanySize(constraintAnimationBuilder)
    } else {
      showCompanySize(constraintAnimationBuilder)
      companyLabel.text = companySize.toString()
      background.setImageResource(R.drawable.znaidy_marker_company)
    }
  }

  private fun hideCompanySize(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.company, View.GONE, constraintAnimationBuilder)
  }

  private fun showCompanySize(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.company, View.VISIBLE, constraintAnimationBuilder)
  }

  private fun setCurrentSpeed(
    currentSpeed: Int,
  ) {
    val speedLabel = findViewById<TextView>(R.id.currentSpeedText)

    if (currentSpeed == 0) {
    } else {
      speedLabel.text = currentSpeed.toString()
    }
  }

  private fun setViewVisibility(
    @IdRes viewId: Int,
    visibility: Int,
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val view = findViewById<View>(viewId)
    if (view.visibility != visibility) {
      constraintAnimationBuilder.addChange { constraintSet ->
        constraintSet.setVisibility(viewId, visibility)
      }
    }
  }

}
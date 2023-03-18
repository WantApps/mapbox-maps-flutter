package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
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

    val zoomSteps = listOf(0.0, 0.5, 0.8, 1.0, 1.2)
  }

  var annotationData: ZnaidyAnnotationData? = null
    private set
  var annotationZoomFactor = 1.0
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
        if (annotationZoomFactor >= 1) {
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

  fun bind(annotation: ZnaidyAnnotationData, zoomFactor: Double) {
    Log.d(TAG, "bind: $annotation")
    val constraintAnimationBuilder = ZnaidyConstraintAnimation.Builder(this)
    setZoomFactor(annotation, zoomFactor)
    when (annotation.markerType) {
      ZnaidyMarkerType.SELF -> bindSelf(annotation, constraintAnimationBuilder)
      ZnaidyMarkerType.FRIEND -> bindFriend(annotation, constraintAnimationBuilder)
      ZnaidyMarkerType.COMPANY -> bindCompany(annotation, constraintAnimationBuilder)
      else -> Unit
    }

    if (annotationZoomFactor != 0.0) {
      setLayout(constraintAnimationBuilder, annotation)
      if (annotationData != null) constraintAnimationBuilder.onAnimationEnd = {
        if (annotationZoomFactor >= 1.0) {
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
//    Log.d(TAG, "bind: constraintAnimation hasChanges=${animation.hasChanges} (${animation.changesCount})")
    if (animation.hasChanges) animation.run()
    annotationData = annotation
  }

  fun bindZoomFactor(zoomFactor: Double) {
    setZoomFactor(annotationData!!, zoomFactor)
    val constraintAnimationBuilder = ZnaidyConstraintAnimation.Builder(this)
    if (annotationZoomFactor != 0.0) {
      setLayout(constraintAnimationBuilder, annotationData!!)
      if (annotationData != null) constraintAnimationBuilder.onAnimationEnd = {
        if (annotationZoomFactor >= 1.0) {
          animator.startIdleAnimation()
          animator.showGlowAnimation()
          if (annotationData!!.markerType != ZnaidyMarkerType.COMPANY) {
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
    constraintAnimationBuilder.build().run()
    Log.d(TAG, "bindZoomFactor: zoomFactor = $annotationZoomFactor")
  }

  fun animateReceiveSticker() {
    animator.animateReceiveSticker()
  }

  fun delete(onAnimationEnd: () -> Unit) {
    animator.animateDeletion(onAnimationEnd)
  }

  private fun setZoomFactor(annotationData: ZnaidyAnnotationData, globalZoomFactor: Double) {
    var factor = if (annotationData.focused) {
      1.2
    } else if (annotationData.markerType != ZnaidyMarkerType.SELF) {
      globalZoomFactor
    } else {
      max(0.5, globalZoomFactor)
    }
    if (annotationData.onlineStatus == ZnaidyOnlineStatus.OFFLINE) {
      factor = zoomSteps[max(zoomSteps.indexOf(factor) - 1, 0)]
    }
    annotationZoomFactor = factor
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
    if (typeChanged || annotationData?.batteryLevel != annotation.batteryLevel || annotationData?.batteryCharging != annotation.batteryCharging) {
      setBatteryLevel(annotation.batteryLevel, annotation.batteryCharging)
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
    if (typeChanged || annotationData?.batteryLevel != annotation.batteryLevel || annotationData?.batteryCharging != annotation.batteryCharging) {
      setBatteryLevel(annotation.batteryLevel, annotation.batteryCharging)
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

  private fun setLayout(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder, annotationData: ZnaidyAnnotationData) {
    constraintAnimationBuilder.addChange { constraintSet ->
      constraintSet.constrainWidth(R.id.markerBackground, getDimen(R.dimen.marker_width, annotationZoomFactor))
      constraintSet.constrainHeight(R.id.markerBackground, getDimen(R.dimen.marker_height, annotationZoomFactor))

      constraintSet.constrainWidth(R.id.avatar, getDimen(R.dimen.avatar_size, annotationZoomFactor))
      constraintSet.constrainHeight(R.id.avatar, getDimen(R.dimen.avatar_size, annotationZoomFactor))
      constraintSet.setMargin(R.id.avatar, ConstraintSet.BOTTOM, getDimen(R.dimen.avatar_offset, annotationZoomFactor))

      constraintSet.setScaleX(R.id.glow, annotationZoomFactor.toFloat())
      constraintSet.setScaleY(R.id.glow, annotationZoomFactor.toFloat())
      val glowMargin = (getDimen(R.dimen.annotation_width_focused) - getDimen(R.dimen.annotation_width_focused, annotationZoomFactor)) / 2
      constraintSet.setMargin(R.id.glow, ConstraintSet.BOTTOM, getDimen(R.dimen.glow_y_offset) - glowMargin)

      if (annotationZoomFactor <= 0.5 || annotationData.currentSpeed <= 0 || annotationData.onlineStatus == ZnaidyOnlineStatus.OFFLINE) {
        constraintSet.setVisibility(R.id.speed, View.GONE)
      } else {
        constraintSet.setVisibility(R.id.speed, View.VISIBLE)
        val speedZoomFactor = if (annotationZoomFactor >= 1.0) 1.0 else 0.7
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

      if (annotationZoomFactor > 1.0 && annotationData.onlineStatus == ZnaidyOnlineStatus.INAPP) {
        constraintSet.setVisibility(R.id.inApp, View.VISIBLE)
      } else {
        constraintSet.setVisibility(R.id.inApp, View.GONE)
      }

      if (annotationZoomFactor > 1.0) {
        constraintSet.setVisibility(R.id.battery, View.VISIBLE)
      } else {
        constraintSet.setVisibility(R.id.battery, View.GONE)
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
    speedLabel.text = currentSpeed.toString()
  }

  @SuppressLint("SetTextI18n")
  private fun setBatteryLevel(batteryLevel: Int, charging: Boolean) {
    val batteryText = findViewById<TextView>(R.id.battery_text)
    val batteryIcon = findViewById<ImageView>(R.id.battery_icon)

    val icon = when {
      charging -> R.drawable.icon_battery_capsule_plugged_size_16
      batteryLevel == 0 -> R.drawable.icon_battery_capsule_unplugged_0_size_16
      batteryLevel in 0 .. 20 -> R.drawable.icon_battery_capsule_unplugged_1_size_16
      batteryLevel in 20 .. 50 -> R.drawable.icon_battery_capsule_unplugged_2_size_16
      batteryLevel in 50 .. 90 -> R.drawable.icon_battery_capsule_unplugged_3_size_16
      batteryLevel in 90 .. 100 -> R.drawable.icon_battery_capsule_unplugged_4_size_16
      else -> R.drawable.icon_battery_capsule_unplugged_4_size_16
    }
    val textColor = when {
      charging -> R.color.battery_charging
      batteryLevel in 0 .. 20 -> R.color.battery_low
      else -> R.color.regular_text
    }

    batteryIcon.setImageResource(icon)
    batteryText.text = "$batteryLevel%"
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      batteryText.setTextColor(context.resources.getColor(textColor, null))
    } else {
      batteryText.setTextColor(context.resources.getColor(textColor))
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
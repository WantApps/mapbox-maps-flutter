package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.DrawableRes
import androidx.constraintlayout.widget.ConstraintLayout
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CircleCrop
import com.bumptech.glide.request.RequestOptions
import com.mapbox.maps.mapbox_maps.R


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
  }

  override fun onViewDetachedFromWindow(v: View?) {
    Log.d(TAG, "onViewDetachedFromWindow: ")
    animator.stopAllAnimations()
  }

  fun bind(annotation: ZnaidyAnnotationData) {
    Log.d(TAG, "bind: $annotation")
    when (annotation.markerType) {
      ZnaidyMarkerType.SELF -> bindSelf(annotation)
      ZnaidyMarkerType.FRIEND -> bindFriend(annotation)
      ZnaidyMarkerType.COMPANY -> bindCompany(annotation)
    }

    if (annotationData != null && annotationData?.focused != annotation.focused) {
      animator.startFocusAnimation(annotation.focused)
    }
    annotationData = annotation
  }

  private fun bindSelf(annotation: ZnaidyAnnotationData) {
    val typeChanged = annotationData?.markerType != annotation.markerType
    if (typeChanged) {
      animator.stopAvatarAnimation()
      setMarkerBackground(R.drawable.znaidy_marker_self)
      hideStickersCount()
      hideCompanySize()
      hideCurrentSpeed()
    }
    if (typeChanged || annotationData?.userAvatar != annotation.userAvatar) {
      setAvatar(annotation.userAvatar)
    }
    if (typeChanged || annotationData?.onlineStatus != annotation.onlineStatus || annotationData?.focused != annotation.focused) {
      setOnlineStatus(annotation.onlineStatus, annotation.focused)
    }
  }


  private fun bindFriend(annotation: ZnaidyAnnotationData) {
    val typeChanged = annotationData?.markerType != annotation.markerType
    if (typeChanged) {
      animator.stopAvatarAnimation()
      setMarkerBackground(R.drawable.znaidy_marker_friend)
      hideCompanySize()
    }
    if (typeChanged || annotationData?.userAvatar != annotation.userAvatar) {
      setAvatar(annotation.userAvatar)
    }
    if (typeChanged || annotationData?.onlineStatus != annotation.onlineStatus || annotationData?.focused != annotation.focused) {
      setOnlineStatus(annotation.onlineStatus, annotation.focused)
    }
    if (typeChanged || annotationData?.stickersCount != annotation.stickersCount) {
      setStickersCount(annotation.stickersCount)
    }
    if (typeChanged || annotationData?.currentSpeed != annotation.currentSpeed) {
      setCurrentSpeed(annotation.currentSpeed)
    }
  }

  private fun bindCompany(annotation: ZnaidyAnnotationData) {
    val typeChanged = annotationData?.markerType != annotation.markerType
    if (typeChanged) {
      setMarkerBackground(R.drawable.znaidy_marker_company)
      showCompanyGlow()
      hideStickersCount()
      hideCurrentSpeed()
    }
    if (typeChanged || annotationData?.avatarUrls != annotation.avatarUrls) {
      setCompanyAvatars(annotation.avatarUrls)
    }
    if (typeChanged || annotationData?.companySize != annotation.companySize) {
      setCompanySize(annotation.companySize)
    }
  }

  private fun setMarkerBackground(@DrawableRes drawable: Int) {
    val background = findViewById<ImageView>(R.id.markerBackground)
    background.setImageResource(drawable)
  }

  private fun setOnlineStatus(onlineStatus: ZnaidyOnlineStatus, focused: Boolean) {
    val markerGlow = findViewById<View>(R.id.glow)
    when (onlineStatus) {
      ZnaidyOnlineStatus.ONLINE -> {
        markerGlow.setBackgroundResource(R.drawable.marker_glow_online)
        animator.startGlowAnimation()
        animator.startIdleAnimation(false)
        hideInApp()
      }
      ZnaidyOnlineStatus.INAPP -> {
        markerGlow.setBackgroundResource(R.drawable.marker_glow_inapp)
        animator.startGlowAnimation()
        animator.startIdleAnimation(focused)
        if (focused) {
          showInApp()
        } else {
          hideInApp()
        }
      }
      ZnaidyOnlineStatus.OFFLINE -> {
        markerGlow.setBackgroundResource(0)
        animator.stopGlowAnimation()
        animator.stopIdleAnimation()
        hideInApp()
      }
    }
  }

  private fun showInApp() {
    val inApp = findViewById<View>(R.id.inApp)
    inApp.visibility = View.VISIBLE
  }

  private fun hideInApp() {
    val inApp = findViewById<View>(R.id.inApp)
    inApp.visibility = View.GONE
  }

  private fun showCompanyGlow() {
    val markerGlow = findViewById<View>(R.id.glow)
    markerGlow.setBackgroundResource(R.drawable.marker_glow_company)
    animator.startGlowAnimation()
    animator.startIdleAnimation(false)
    hideInApp()
  }

  private fun setStickersCount(stickersCount: Int) {
    val stickerContainer = findViewById<View>(R.id.stickers)
    val stickerLabel = findViewById<TextView>(R.id.stickerCounterText)

    if (stickersCount == 0) {
      stickerContainer.visibility = View.GONE
    } else {
      stickerContainer.visibility = View.VISIBLE
      stickerLabel.text = if (stickersCount <= 9) stickersCount.toString() else "9+"
    }
  }

  private fun hideStickersCount() {
    setStickersCount(0)
  }

  private fun setAvatar(avatarUrl: String?) {
    val avatarView = findViewById<ImageView>(R.id.profileIcon)

    val request = if (avatarUrl != null) {
      Glide.with(this)
        .load(avatarUrl)
    } else {
      Glide.with(this)
        .load(R.drawable.profile_daniel)
    }
    request
      .error(R.drawable.profile_daniel)
      .apply(RequestOptions.bitmapTransform(CircleCrop()))
      .into(avatarView)
  }

  private fun setCompanyAvatars(avatarUrls: List<String>) {
    animator.startAvatarAnimation(avatarUrls.size) {
      setAvatar(avatarUrls[it])
    }
  }

  private fun setCompanySize(companySize: Int) {
    val companyContainer = findViewById<View>(R.id.company)
    val companyLabel = findViewById<TextView>(R.id.companySizeText)
    val background = findViewById<ImageView>(R.id.markerBackground)

    if (companySize == 0) {
      companyContainer.visibility = View.GONE
    } else {
      companyContainer.visibility = View.VISIBLE
      companyLabel.text = companySize.toString()
      background.setImageResource(R.drawable.znaidy_marker_company)
    }
  }

  private fun hideCompanySize() {
    setCompanySize(0)
  }

  private fun setCurrentSpeed(currentSpeed: Int) {
    val speedContainer = findViewById<View>(R.id.speed)
    val speedLabel = findViewById<TextView>(R.id.currentSpeedText)

    if (currentSpeed == 0) {
      speedContainer.visibility = View.GONE
    } else {
      speedContainer.visibility = View.VISIBLE
      speedLabel.text = currentSpeed.toString()
    }
  }

  private fun hideCurrentSpeed() {
    setCurrentSpeed(0)
  }
}
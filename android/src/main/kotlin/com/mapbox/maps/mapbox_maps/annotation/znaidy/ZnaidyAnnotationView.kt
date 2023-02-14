package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.animation.ValueAnimator
import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
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

  private var glowAnimator: ValueAnimator? = null

  init {
    LayoutInflater.from(context).inflate(R.layout.znaidy_annotation, this)
    addOnAttachStateChangeListener(this)
  }

  override fun onViewAttachedToWindow(v: View?) {
    Log.d(TAG, "onViewAttachedToWindow: ")
  }

  override fun onViewDetachedFromWindow(v: View?) {
    Log.d(TAG, "onViewDetachedFromWindow: ")
    glowAnimator?.cancel()
  }

  fun bind(annotation: ZnaidyAnnotationData) {
    Log.d(TAG, "bind: $annotation")
    updateSelf(annotation.isSelf)
    updateGlow(annotation.onlineStatus)
    updateStickersCount(annotation.stickersCount)
    updateCurrentSpeed(annotation.currentSpeed)
    updateCompany(annotation.companySize)
    updateAvatar(annotation.avatarUrls.firstOrNull())
    annotationData = annotation
  }

  private fun updateSelf(isSelf: Boolean) {
    if (annotationData?.isSelf != isSelf) {
      setSelf(isSelf)
    }
  }

  private fun updateGlow(onlineStatus: ZnaidyOnlineStatus) {
    if (annotationData?.onlineStatus != onlineStatus) {
      setGlow(onlineStatus)
    }
  }

  private fun updateStickersCount(stickersCount: Int) {
    if (annotationData?.stickersCount != stickersCount) {
      setStickersCount(stickersCount)
    }
  }

  private fun updateAvatar(avatarUrl: String?) {
//    //TODO remove after done with avatar
//    setAvatar(avatarUrl)
    if (annotationData?.avatarUrls?.firstOrNull() != avatarUrl) {
      setAvatar(avatarUrl)
    }
  }

  private fun updateCompany(companySize: Int) {
    if (annotationData?.companySize != companySize) {
      setCompany(companySize)
    }
  }

  private fun updateCurrentSpeed(currentSpeed: Int) {
    if (annotationData?.currentSpeed != currentSpeed) {
      setCurrentSpeed(currentSpeed)
    }
  }

  private fun setSelf(isSelf: Boolean) {
    val background = findViewById<ImageView>(R.id.background)
    background.setImageResource(
      if (isSelf) R.drawable.znaidy_marker_self else R.drawable.znaidy_marker_friend
    )
  }

  private fun setGlow(onlineStatus: ZnaidyOnlineStatus) {
    glowAnimator?.cancel()
    val markerGlow = findViewById<View>(R.id.glow)
    if (onlineStatus == ZnaidyOnlineStatus.OFFLINE) {
      markerGlow.setBackgroundResource(R.drawable.marker_glow_offline)
    } else {
      markerGlow.setBackgroundResource(R.drawable.marker_glow_online)
    }
    glowAnimator = ValueAnimator.ofFloat(1f, 0.5f, 1f).apply {
      duration = 2000L
      addUpdateListener { animation ->
        val value = animation.animatedValue.toString().toFloatOrNull() ?: 1f
        markerGlow.alpha = value
      }
      repeatCount = ValueAnimator.INFINITE
    }
    glowAnimator?.start()
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

  private fun setCompany(companySize: Int) {
    val companyContainer = findViewById<View>(R.id.company)
    val companyLabel = findViewById<TextView>(R.id.companySizeText)
    val background = findViewById<ImageView>(R.id.background)

    if (companySize == 0) {
      companyContainer.visibility = View.GONE
    } else {
      companyContainer.visibility = View.VISIBLE
      companyLabel.text = companySize.toString()
      background.setImageResource(R.drawable.znaidy_marker_company)
    }
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


}
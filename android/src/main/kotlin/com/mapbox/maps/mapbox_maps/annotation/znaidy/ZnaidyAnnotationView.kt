package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.content.Context
import android.transition.*
import android.util.AttributeSet
import android.util.Log
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
    val constraintAnimationBuilder = ZnaidyConstraintAnimation.Builder(this)
    when (annotation.markerType) {
      ZnaidyMarkerType.SELF -> bindSelf(annotation, constraintAnimationBuilder)
      ZnaidyMarkerType.FRIEND -> bindFriend(annotation, constraintAnimationBuilder)
      ZnaidyMarkerType.COMPANY -> bindCompany(annotation, constraintAnimationBuilder)
    }

    if (annotation.focused && annotation.onlineStatus == ZnaidyOnlineStatus.INAPP && annotation.markerType != ZnaidyMarkerType.COMPANY) {
      showInApp(constraintAnimationBuilder)
    } else {
      hideInApp(constraintAnimationBuilder)
    }

    if (annotation.focused) {
      setFocusedSize(constraintAnimationBuilder)
      constraintAnimationBuilder.onAnimationEnd = {
        animator.startIdleAnimation()
      }
    } else if (annotation.onlineStatus == ZnaidyOnlineStatus.OFFLINE && annotation.markerType != ZnaidyMarkerType.COMPANY) {
      setOfflineSize(constraintAnimationBuilder)
      constraintAnimationBuilder.onAnimationEnd = {
        animator.stopIdleAnimation()
      }
    } else {
      setRegularSize(constraintAnimationBuilder)
      constraintAnimationBuilder.onAnimationEnd = {
        animator.startIdleAnimation()
      }
    }

    val animation = constraintAnimationBuilder.build()
    Log.d(TAG, "bind: constraintAnimation hasChanges=${animation.hasChanges} (${animation.changesCount})")
    if (animation.hasChanges) animation.run()
    annotationData = annotation
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
      hideCurrentSpeed(constraintAnimationBuilder)
    }
    if (typeChanged || annotationData?.userAvatar != annotation.userAvatar) {
      setAvatar(annotation.userAvatar)
    }
    if (typeChanged || annotationData?.onlineStatus != annotation.onlineStatus || annotationData?.focused != annotation.focused) {
      setOnlineStatus(annotation.onlineStatus)
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
      setCurrentSpeed(annotation.currentSpeed, constraintAnimationBuilder)
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
      hideCurrentSpeed(constraintAnimationBuilder)
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

  private fun setFocusedSize(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    val markerBackground = findViewById<View>(R.id.markerBackground)
    Log.d(
      TAG, "setFocusedSize: markerWidth=${markerBackground.width}," +
        " dimen_focused=${getDimen(R.dimen.marker_width_focused)}," +
        " dimen_regular=${getDimen(R.dimen.marker_width)}," +
        " dimen_offline=${getDimen(R.dimen.marker_width_offline)}"
    )
    if (markerBackground.width != getDimen(R.dimen.marker_width_focused)) {
      constraintAnimationBuilder.addChange { constraintSet ->
        constraintSet.constrainWidth(R.id.markerBackground, getDimen(R.dimen.marker_width_focused))
        constraintSet.constrainHeight(
          R.id.markerBackground,
          getDimen(R.dimen.marker_height_focused)
        )
        constraintSet.constrainWidth(R.id.avatar, getDimen(R.dimen.avatar_size_focused))
        constraintSet.constrainHeight(R.id.avatar, getDimen(R.dimen.avatar_size_focused))
      }
    }
  }

  private fun setRegularSize(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    val markerBackground = findViewById<View>(R.id.markerBackground)
    Log.d(
      TAG, "setRegularSize: markerWidth=${markerBackground.width}," +
        " dimen_focused=${getDimen(R.dimen.marker_width_focused)}," +
        " dimen_regular=${getDimen(R.dimen.marker_width)}," +
        " dimen_offline=${getDimen(R.dimen.marker_width_offline)}"
    )
    if (markerBackground.width != getDimen(R.dimen.marker_width)) {
      constraintAnimationBuilder.addChange { constraintSet ->
        constraintSet.constrainWidth(R.id.markerBackground, getDimen(R.dimen.marker_width))
        constraintSet.constrainHeight(R.id.markerBackground, getDimen(R.dimen.marker_height))
        constraintSet.constrainWidth(R.id.avatar, getDimen(R.dimen.avatar_size))
        constraintSet.constrainHeight(R.id.avatar, getDimen(R.dimen.avatar_size))
      }
    }
  }

  private fun setOfflineSize(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    val markerBackground = findViewById<View>(R.id.markerBackground)
    Log.d(
      TAG, "setOfflineSize: markerWidth=${markerBackground.width}," +
        " dimen_focused=${getDimen(R.dimen.marker_width_focused)}," +
        " dimen_regular=${getDimen(R.dimen.marker_width)}," +
        " dimen_offline=${getDimen(R.dimen.marker_width_offline)}"
    )
    if (markerBackground.width != getDimen(R.dimen.marker_width_offline)) {
      constraintAnimationBuilder.addChange { constraintSet ->
        constraintSet.constrainWidth(R.id.markerBackground, getDimen(R.dimen.marker_width_offline))
        constraintSet.constrainHeight(
          R.id.markerBackground,
          getDimen(R.dimen.marker_height_offline)
        )
        constraintSet.constrainWidth(R.id.avatar, getDimen(R.dimen.avatar_size_offline))
        constraintSet.constrainHeight(R.id.avatar, getDimen(R.dimen.avatar_size_offline))
      }
    }
  }

  private fun getDimen(@DimenRes dimen: Int): Int {
    return context.resources.getDimensionPixelOffset(dimen)
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
    constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder
  ) {
    val speedLabel = findViewById<TextView>(R.id.currentSpeedText)

    if (currentSpeed == 0) {
      hideCurrentSpeed(constraintAnimationBuilder)
    } else {
      showCurrentSpeed(constraintAnimationBuilder)
      speedLabel.text = currentSpeed.toString()
    }
  }

  private fun hideCurrentSpeed(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.speed, View.GONE, constraintAnimationBuilder)
  }

  private fun showCurrentSpeed(constraintAnimationBuilder: ZnaidyConstraintAnimation.Builder) {
    setViewVisibility(R.id.speed, View.VISIBLE, constraintAnimationBuilder)
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
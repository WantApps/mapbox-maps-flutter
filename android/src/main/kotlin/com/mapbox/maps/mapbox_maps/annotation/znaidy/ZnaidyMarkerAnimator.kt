package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.animation.Animator
import android.animation.Animator.AnimatorListener
import android.animation.ValueAnimator
import android.util.Log
import android.view.View
import com.mapbox.maps.mapbox_maps.R
import java.util.Timer
import java.util.TimerTask

class ZnaidyMarkerAnimator(private val annotationView: ZnaidyAnnotationView) {

  private var glowAnimator: ValueAnimator? = null
  private var markerIdleAnimator: ValueAnimator? = null
  private var companyAvatarAnimator: Timer? = null

  var glowActive = glowAnimator != null
  var markerIdleActive = markerIdleAnimator != null

  fun stopAllAnimations() {
    glowAnimator?.cancel()
    markerIdleAnimator?.cancel()
    companyAvatarAnimator?.cancel()
  }

  fun startGlowAnimation() {
    glowAnimator?.cancel()
    val glowView = annotationView.findViewById<View>(R.id.glow)
    glowAnimator = ValueAnimator.ofFloat(0.5f, 1f).apply {
      duration = 2000L
      repeatMode = ValueAnimator.REVERSE
      addUpdateListener { animation ->
        val value = animation.animatedValue.toString().toFloatOrNull() ?: 1f
        glowView.alpha = value
      }
      repeatCount = ValueAnimator.INFINITE
    }
    glowAnimator?.start()
  }

  fun stopGlowAnimation() {
    glowAnimator?.cancel()
  }

  fun startIdleAnimation() {
    startIdleAnimation(1.0f)
  }

  private fun startIdleAnimation(baseValue: Float) {
    Log.d(ZnaidyAnnotationView.TAG, "startIdleAnimation: base = $baseValue")
    markerIdleAnimator?.cancel()
    val background = annotationView.findViewById<View>(R.id.markerBackground)
    val avatar = annotationView.findViewById<View>(R.id.avatar)

    markerIdleAnimator = ValueAnimator.ofFloat(
      baseValue,
      baseValue + 0.01f,
      baseValue + 0.03f,
      baseValue,
      baseValue - 0.03f,
      baseValue - 0.01f,
      baseValue
    ).apply {
      duration = 2000L
      repeatCount = ValueAnimator.INFINITE
      repeatMode = ValueAnimator.REVERSE
      addUpdateListener { animator ->
        val value = animator.animatedValue.toString().toFloatOrNull() ?: baseValue
        background.scaleX = value
        background.scaleY = baseValue
        avatar.scaleX = value
        avatar.scaleY = baseValue / value
      }
    }
    markerIdleAnimator?.start()
  }

  fun stopIdleAnimation() {
    markerIdleAnimator?.cancel()
  }

  fun startAvatarAnimation(count: Int, onTick: ((Int) -> Unit)) {
    var tick = -1
    companyAvatarAnimator?.cancel()
    companyAvatarAnimator = Timer()
    companyAvatarAnimator?.schedule(
      object : TimerTask() {
        override fun run() {
          annotationView.post { onTick(tick) }
          tick = (tick + 1).rem(count)
        }
      },
      0L, 2000L
    )
  }

  fun stopAvatarAnimation() {
    companyAvatarAnimator?.cancel()
  }
}
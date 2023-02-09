package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.animation.ValueAnimator
import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.animation.AnimationSet
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.Guideline
import com.mapbox.maps.mapbox_maps.R

class ZnaidyAnnotationView @JvmOverloads constructor(
  context: Context, attrs: AttributeSet? = null
) : ConstraintLayout(context, attrs), View.OnAttachStateChangeListener {

  private val animations: AnimationSet = AnimationSet(true)
  private var scaleAnimator: ValueAnimator? = null

  init {
    LayoutInflater.from(context).inflate(R.layout.znaidy_annotation, this)
    addOnAttachStateChangeListener(this)
  }

  override fun onViewAttachedToWindow(v: View?) {
    bindLayout()
  }

  override fun onViewDetachedFromWindow(v: View?) {
    animations.cancel()
  }

  private fun bindLayout() {
    val pfpTopGuideline = findViewById<Guideline>(R.id.pfpTopGuideline)
    val pfpBottomGuideline = findViewById<Guideline>(R.id.pfpBottomGuideline)
    val pfpStartGuideline = findViewById<Guideline>(R.id.pfpStartGuideline)
    val pfpEndGuideline = findViewById<Guideline>(R.id.pfpEndGuideline)


    val animationRoot = findViewById<ConstraintLayout>(R.id.animationRoot)
    val markerGlow = findViewById<View>(R.id.markerGlow)
    val scaleAnimator = ValueAnimator.ofFloat(1f, 0.5f, 1f)
    scaleAnimator.duration = 1000L
    scaleAnimator.addUpdateListener { animation ->
      val value = animation.animatedValue.toString().toFloatOrNull() ?: 1f
//      animationRoot.scaleX = value
//      animationRoot.scaleY = value
      markerGlow.alpha = value
    }
    scaleAnimator.repeatCount = ValueAnimator.INFINITE
    scaleAnimator.start()
  }


}
package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.transition.AutoTransition
import android.transition.Transition
import android.transition.TransitionManager
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import com.mapbox.maps.mapbox_maps.R

typealias ConstraintAnimationChange = (ConstraintSet, ConstraintSet) -> Unit

class ZnaidyConstraintAnimation private constructor(
  private val znaidyAnnotationView: ZnaidyAnnotationView,
  private val changes: List<ConstraintAnimationChange>,
  private val onAnimationEnd: (() -> Unit),
  private val duration: Long,
  private val transition: Transition,
) {

  var hasChanges = changes.isNotEmpty()
  var changesCount = changes.size

  data class Builder(
    val znaidyAnnotationView: ZnaidyAnnotationView,
    private var changes: List<ConstraintAnimationChange> = listOf(),
    var onAnimationEnd: (() -> Unit) = {},
    var duration: Long = 200L,
    var transition: Transition = AutoTransition(),
  ) {

    fun addChange(change: ConstraintAnimationChange) {
      changes = changes.toMutableList().apply { add(change) }
    }

    fun build(): ZnaidyConstraintAnimation {
      return ZnaidyConstraintAnimation(
        znaidyAnnotationView,
        changes,
        onAnimationEnd,
        duration,
        transition,
      )
    }
  }

  fun run() {
    constraintAnimation()
  }

  private fun constraintAnimation() {
    val root = znaidyAnnotationView.findViewById<ConstraintLayout>(R.id.annotationRoot)
    val animationContainer = znaidyAnnotationView.findViewById<ConstraintLayout>(R.id.animationContainer)
    val rootConstraintSet = ConstraintSet()
    rootConstraintSet.clone(root)
    val animConstraintSet = ConstraintSet()
    animConstraintSet.clone(animationContainer)
    changes.forEach { change -> change(rootConstraintSet, animConstraintSet) }
    transition.duration = duration
    transition.addListener(object : Transition.TransitionListener {
      override fun onTransitionStart(transition: Transition?) {
      }

      override fun onTransitionEnd(transition: Transition?) {
        onAnimationEnd()
      }

      override fun onTransitionCancel(transition: Transition?) {
      }

      override fun onTransitionPause(transition: Transition?) {
      }

      override fun onTransitionResume(transition: Transition?) {
      }

    })
    TransitionManager.beginDelayedTransition(root, transition)
    rootConstraintSet.applyTo(root)
    animConstraintSet.applyTo(animationContainer)
  }
}
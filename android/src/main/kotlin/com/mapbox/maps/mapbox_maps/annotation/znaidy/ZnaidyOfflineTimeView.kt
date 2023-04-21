package com.mapbox.maps.mapbox_maps.annotation.znaidy

import android.annotation.TargetApi
import android.content.Context
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.TextPaint
import android.text.style.MetricAffectingSpan
import android.text.style.RelativeSizeSpan
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import com.mapbox.maps.mapbox_maps.R
import java.time.Instant
import java.time.ZoneId
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.util.*
import kotlin.math.floor
import kotlin.math.roundToInt


class ZnaidyOfflineTimeView @JvmOverloads constructor(
  context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : ConstraintLayout(context, attrs, defStyleAttr), View.OnAttachStateChangeListener {

  companion object {
    val supportedLocales = listOf("en", "uk", "ru")
  }

  private var offlineTimeUpdater: Timer? = null

  init {
    LayoutInflater.from(context).inflate(R.layout.znaidy_offline_time, this)
    addOnAttachStateChangeListener(this)
  }

  override fun onViewAttachedToWindow(v: View?) {

  }

  override fun onViewDetachedFromWindow(v: View?) {
    stopUpdates()
  }

  fun setOfflineTime(offlineTimestamp: Long) {
    startUpdates(offlineTimestamp)
  }

  private fun onUpdateTick(offlineTimestamp: Long) {
    val offlineTime = (System.currentTimeMillis() - offlineTimestamp) / 1000

    val showDate = offlineTime > 86400 * 7 && offlineTime < 86400 * 356
    if (showDate) {
      updateLastSeenDate(offlineTimestamp)
    } else {
      updateOfflineTime(offlineTime)
    }
  }

  private fun updateLastSeenDate(offlineTimestamp: Long) {
    val offlineLabel = findViewById<TextView>(R.id.offline_label)
    val timeLabel = findViewById<TextView>(R.id.offline_time_label)
    val zonedTime =
      ZonedDateTime.ofInstant(Instant.ofEpochMilli(offlineTimestamp), ZoneId.systemDefault())
    val format = DateTimeFormatter.ofPattern("dd MMM", getLocale())
    offlineLabel.text = context.getString(R.string.offline_since)
    val formattedDate = format.format(zonedTime).uppercase().replace(".", "")
    val parts = formattedDate.split(" ")
    val spannable = SpannableStringBuilder().apply {
      append(parts[0])
      append(" ", RelativeSizeSpan(0.5f), Spanned.SPAN_MARK_MARK)
      parts[1].let {
        append(if (it.length > 3) it.substring(0, 3) else it)
      }
    }
    timeLabel.text = spannable
  }

  private fun updateOfflineTime(offlineTime: Long) {
    val offlineLabel = findViewById<TextView>(R.id.offline_label)
    val timeLabel = findViewById<TextView>(R.id.offline_time_label)
    if (offlineTime > 86400 * 7) {
      val years = floor(offlineTime / (86400.0 * 356)).toInt()
      val month = floor((offlineTime - (years * 86400 * 356)) / (86400.0 * 30)).toInt()
      offlineLabel.text = context.getString(R.string.offline_for)
      if (month == 0) {
        val spannable = SpannableStringBuilder().apply {
          append("$years")
          append(" ", RelativeSizeSpan(0.5f), Spanned.SPAN_MARK_MARK)
          append(context.getString(R.string.time_unit_year))
        }
        timeLabel.text = spannable
      } else {
        val spannable = SpannableStringBuilder().apply {
          append("${years}${context.getString(R.string.time_unit_year)}")
          append(" ", RelativeSizeSpan(0.5f), Spanned.SPAN_MARK_MARK)
          append("${month}${context.getString(R.string.time_unit_month)}")
        }
        timeLabel.text = spannable
      }
    } else {
      val time: Int
      val unit: String
      if (offlineTime < 3600) {
        time = floor(offlineTime / 60.0).toInt()
        unit = context.resources.getQuantityString(R.plurals.time_unit_min, time)
      } else if (offlineTime < 86400) {
        time = floor(offlineTime / 3600.0).toInt()
        unit = context.resources.getQuantityString(R.plurals.time_unit_hour, time)
      } else {
        time = floor(offlineTime / 86400.0).toInt()
        unit = context.resources.getQuantityString(R.plurals.time_unit_day, time)
      }
      offlineLabel.text = context.getString(R.string.offline_for)
      val spannable = SpannableStringBuilder().apply {
        append(time.toString())
        append(" ", RelativeSizeSpan(0.5f), Spanned.SPAN_MARK_MARK)
        append(unit)
      }
      timeLabel.text = spannable
    }
  }

  private fun getLocale(): Locale {
    val defaultLocale = Locale.getDefault()
    return if (defaultLocale.language !in supportedLocales) {
      Locale.US
    } else {
      defaultLocale
    }
  }

  private fun startUpdates(offlineTimestamp: Long) {
    val offlineTime = (System.currentTimeMillis() - offlineTimestamp) / 1000

    offlineTimeUpdater?.cancel()
    offlineTimeUpdater = Timer()
    offlineTimeUpdater?.schedule(object : TimerTask() {
      override fun run() {
        post {
          onUpdateTick(offlineTimestamp)
        }
      }
    }, 0L, 60000L)
  }

  private fun stopUpdates() {
    offlineTimeUpdater?.cancel()
    offlineTimeUpdater = null
  }

}

@TargetApi(21)
class LetterSpacingSpan
/**
 * @param letterSpacing
 */(val letterSpacing: Float) : MetricAffectingSpan() {

  override fun updateDrawState(ds: TextPaint) {
    apply(ds)
  }

  override fun updateMeasureState(paint: TextPaint) {
    apply(paint)
  }

  private fun apply(paint: TextPaint) {
    paint.letterSpacing = letterSpacing
  }
}
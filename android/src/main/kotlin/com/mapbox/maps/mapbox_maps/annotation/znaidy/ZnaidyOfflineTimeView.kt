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
import java.time.*
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import java.util.*
import kotlin.math.floor


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
    val lastOnlineDate = LocalDateTime.ofInstant(Instant.ofEpochMilli(offlineTimestamp), ZoneId.systemDefault())
    val diffDays = ChronoUnit.DAYS.between(lastOnlineDate, LocalDateTime.now())
    val diffYear = ChronoUnit.YEARS.between(lastOnlineDate, LocalDateTime.now())

    val showDate = diffDays >= 7 && diffYear < 1
    if (showDate) {
      updateLastSeenDate(lastOnlineDate)
    } else {
      updateOfflineTime(lastOnlineDate)
    }
  }

  private fun updateLastSeenDate(lastOnlineTime: LocalDateTime) {
    val offlineLabel = findViewById<TextView>(R.id.offline_label)
    val timeLabel = findViewById<TextView>(R.id.offline_time_label)
    val format = DateTimeFormatter.ofPattern("d MMM", getLocale())
    offlineLabel.text = context.getString(R.string.offline_since)
    val formattedDate = format.format(lastOnlineTime).uppercase().replace(".", "")
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

  private fun updateOfflineTime(lastOnlineTime: LocalDateTime) {
    val offlineLabel = findViewById<TextView>(R.id.offline_label)
    val timeLabel = findViewById<TextView>(R.id.offline_time_label)
    if (ChronoUnit.DAYS.between(lastOnlineTime, LocalDateTime.now()) > 7) {
      offlineLabel.text = context.getString(R.string.offline_for)
      val period = Period.between(lastOnlineTime.toLocalDate(), LocalDate.now())
      if (period.months.rem(12) == 0) {
        val spannable = SpannableStringBuilder().apply {
          append("${period.years}")
          append(" ", RelativeSizeSpan(0.5f), Spanned.SPAN_MARK_MARK)
          append(context.getString(R.string.time_unit_year))
        }
        timeLabel.text = spannable
      } else {
        val spannable = SpannableStringBuilder().apply {
          append("${period.years}${context.getString(R.string.time_unit_year)}")
          append(" ", RelativeSizeSpan(0.5f), Spanned.SPAN_MARK_MARK)
          append("${period.months}${context.getString(R.string.time_unit_month)}")
        }
        timeLabel.text = spannable
      }
    } else {
      val time: Int
      val unit: String
      val duration = Duration.between(lastOnlineTime, LocalDateTime.now())
      if (duration.toMinutes() < 60) {
        time = duration.toMinutes().toInt()
        unit = context.resources.getQuantityString(R.plurals.time_unit_min, time)
      } else if (duration.toHours() < 24) {
        time = duration.toHours().toInt()
        unit = context.resources.getQuantityString(R.plurals.time_unit_hour, time)
      } else {
        time = duration.toDays().toInt()
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

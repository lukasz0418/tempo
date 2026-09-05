package com.franek.tempo

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import java.util.Calendar

/**
 * Przypomnienia oparte wprost o [AlarmManager].
 *
 * Napisane natywnie zamiast przez `flutter_local_notifications`, bo tamta
 * biblioteka ciągnie implementację dla Windowsa wymagającą nagłówków ATL,
 * których nie ma w Visual Studio Build Tools — przez co psuła build
 * aplikacji desktopowej. Przypomnienia i tak są funkcją telefonu,
 * więc zależność kosztowała więcej, niż dawała.
 *
 * Alarmy są **nieprecyzyjne** (`setInexactRepeating`): tryb dokładny wymaga
 * uprawnienia SCHEDULE_EXACT_ALARM, a przy przypomnieniu o ćwiczeniu
 * kilka minut różnicy nie ma znaczenia. W zamian system może je grupować,
 * co oszczędza baterię.
 */
object Reminders {

    const val CHANNEL_ID = "tempo_reminders"
    private const val CHANNEL_NAME = "Przypomnienia"

    const val EXTRA_ID = "reminder_id"
    const val EXTRA_TITLE = "reminder_title"
    const val EXTRA_BODY = "reminder_body"

    /** Przechowuje zaplanowane przypomnienia, żeby dało się je odtworzyć po restarcie. */
    private const val PREFS = "tempo_reminders"
    private const val KEY_PAYLOAD = "payload"

    /**
     * Jeden wpis: identyfikator, treść, minuta doby i dni tygodnia.
     *
     * [weekdays] w konwencji `java.util.Calendar` (niedziela = 1).
     * Pusta lista oznacza „codziennie".
     */
    data class Reminder(
        val id: String,
        val title: String,
        val body: String?,
        val minuteOfDay: Int,
        val weekdays: List<Int>
    )

    fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = context.getSystemService(NotificationManager::class.java) ?: return
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return

        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Przypomnienia o ćwiczeniach i celach"
            }
        )
    }

    /**
     * Kasuje wszystkie dotychczasowe alarmy i planuje podane od nowa.
     *
     * Pełne odtworzenie zamiast różnicowania: stan i tak trzeba umieć
     * odbudować po restarcie telefonu, więc jedna droga jest prostsza
     * i mniej podatna na rozjazd niż dwie.
     */
    fun reschedule(context: Context, reminders: List<Reminder>) {
        ensureChannel(context)
        cancelAll(context)
        persist(context, reminders)

        val alarms = context.getSystemService(AlarmManager::class.java) ?: return

        for (reminder in reminders) {
            val days = if (reminder.weekdays.isEmpty()) listOf(0) else reminder.weekdays
            for (day in days) {
                val triggerAt = nextTrigger(reminder.minuteOfDay, day)
                alarms.setInexactRepeating(
                    AlarmManager.RTC_WAKEUP,
                    triggerAt,
                    if (day == 0) AlarmManager.INTERVAL_DAY else AlarmManager.INTERVAL_DAY * 7,
                    pendingIntent(context, reminder, day)
                )
            }
        }
    }

    fun cancelAll(context: Context) {
        val alarms = context.getSystemService(AlarmManager::class.java) ?: return
        for (reminder in load(context)) {
            val days = if (reminder.weekdays.isEmpty()) listOf(0) else reminder.weekdays
            for (day in days) {
                alarms.cancel(pendingIntent(context, reminder, day))
            }
        }
    }

    /** Odtworzenie alarmów po restarcie telefonu albo aktualizacji aplikacji. */
    fun restore(context: Context) {
        val stored = load(context)
        if (stored.isNotEmpty()) reschedule(context, stored)
    }

    private fun pendingIntent(context: Context, reminder: Reminder, day: Int): PendingIntent {
        val intent = Intent(context, ReminderReceiver::class.java).apply {
            putExtra(EXTRA_ID, reminder.id)
            putExtra(EXTRA_TITLE, reminder.title)
            putExtra(EXTRA_BODY, reminder.body)
            // Bez unikalnego `data` system uznałby wszystkie intencje za
            // tożsame (extras nie biorą udziału w porównaniu) i zostawił
            // tylko jeden alarm z całego zestawu.
            data = android.net.Uri.parse("tempo://reminder/${reminder.id}/$day")
        }

        return PendingIntent.getBroadcast(
            context,
            requestCode(reminder.id, day),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun requestCode(id: String, day: Int): Int = (id.hashCode() and 0x00FFFFFF) * 10 + day

    /**
     * Najbliższe wystąpienie danej godziny.
     *
     * [weekday] równe 0 oznacza „codziennie" — bierzemy wtedy najbliższą
     * dobę. Godzina jest wyliczana w czasie lokalnym urządzenia, więc
     * przypomnienie „o 19:00" zostaje o 19:00 także po zmianie czasu.
     */
    private fun nextTrigger(minuteOfDay: Int, weekday: Int): Long {
        val now = Calendar.getInstance()
        val target = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, minuteOfDay / 60)
            set(Calendar.MINUTE, minuteOfDay % 60)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        if (weekday in 1..7) {
            while (target.get(Calendar.DAY_OF_WEEK) != weekday || !target.after(now)) {
                target.add(Calendar.DAY_OF_MONTH, 1)
            }
        } else if (!target.after(now)) {
            target.add(Calendar.DAY_OF_MONTH, 1)
        }

        return target.timeInMillis
    }

    // --- zapamiętywanie ----------------------------------------------------
    //
    // Prosty format tekstowy zamiast JSON-a: rekordów jest kilka, a pola
    // są znane, więc parser biblioteczny byłby tu zależnością bez powodu.
    // Rozdzielacze to znaki, które nie wystąpią w treści przypomnienia.

    // Znaki sterujace ASCII przeznaczone dokladnie do tego celu: 0x1E
    // rozdziela rekordy, 0x1F pola. Nie da sie ich wpisac z klawiatury,
    // wiec nie pojawia sie w tresci przypomnienia i nie rozwala parsowania.
    // Zapisane jawnym kodem, bo surowy znak sterujacy w zrodle jest
    // niewidoczny i pierwsza osoba sprzatajaca te linijke zepsulaby ja bez sladu.
    private const val RECORD_SEPARATOR = "\u001E"
    private const val FIELD_SEPARATOR = "\u001F"

    private fun persist(context: Context, reminders: List<Reminder>) {
        val payload = reminders.joinToString(RECORD_SEPARATOR) { r ->
            listOf(
                r.id,
                r.title,
                r.body ?: "",
                r.minuteOfDay.toString(),
                r.weekdays.joinToString(",")
            ).joinToString(FIELD_SEPARATOR)
        }
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_PAYLOAD, payload)
            .apply()
    }

    private fun load(context: Context): List<Reminder> {
        val payload = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getString(KEY_PAYLOAD, null)
            ?: return emptyList()
        if (payload.isEmpty()) return emptyList()

        return payload.split(RECORD_SEPARATOR).mapNotNull { record ->
            val parts = record.split(FIELD_SEPARATOR)
            if (parts.size < 5) return@mapNotNull null

            Reminder(
                id = parts[0],
                title = parts[1],
                body = parts[2].ifEmpty { null },
                minuteOfDay = parts[3].toIntOrNull() ?: return@mapNotNull null,
                weekdays = parts[4].split(",").mapNotNull(String::toIntOrNull)
            )
        }
    }
}

/** Wyświetla powiadomienie w momencie zadziałania alarmu. */
class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Reminders.ensureChannel(context)

        val title = intent.getStringExtra(Reminders.EXTRA_TITLE) ?: "Tempo"
        val body = intent.getStringExtra(Reminders.EXTRA_BODY)
        val id = intent.getStringExtra(Reminders.EXTRA_ID) ?: ""

        // Otwarcie aplikacji po dotknięciu powiadomienia.
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val contentIntent = launch?.let {
            PendingIntent.getActivity(
                context,
                id.hashCode(),
                it,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        val notification: Notification =
            Notification.Builder(context, Reminders.CHANNEL_ID)
                .setContentTitle(title)
                .apply {
                    if (!body.isNullOrEmpty()) setContentText(body)
                    if (contentIntent != null) setContentIntent(contentIntent)
                }
                .setSmallIcon(android.R.drawable.ic_popup_reminder)
                .setAutoCancel(true)
                .build()

        val manager = context.getSystemService(NotificationManager::class.java) ?: return
        manager.notify(id.hashCode(), notification)
    }
}

/**
 * Odtwarza alarmy po restarcie telefonu i po aktualizacji aplikacji.
 *
 * Android kasuje w obu tych sytuacjach wszystkie zaplanowane alarmy.
 * Bez tego odbiornika przypomnienia po cichu przestałyby przychodzić —
 * najgorszy rodzaj awarii, bo niewidoczny.
 */
class ReminderBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            "android.intent.action.QUICKBOOT_POWERON" -> Reminders.restore(context)
        }
    }
}

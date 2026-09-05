import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../db/daos/reminder_dao.dart';
import '../db/database.dart';

/// Powiadomienia z przypomnieniami o ćwiczeniach.
///
/// Źródłem prawdy jest tabela `reminders`, a zaplanowane alarmy to tylko jej
/// odbicie w systemie. Android kasuje wszystkie zaplanowane powiadomienia
/// przy restarcie telefonu i przy aktualizacji aplikacji, więc [rescheduleAll]
/// leci przy każdym starcie — inaczej po pierwszym restarcie przypomnienia
/// po cichu przestałyby przychodzić.
class NotificationService {
  NotificationService(this._db);

  final AppDatabase _db;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  static const _channelId = 'tempo_reminders';
  static const _channelName = 'Przypomnienia';

  ReminderDao get _dao => _db.reminderDao;

  Future<void> init() async {
    if (_ready) return;

    tz_data.initializeTimeZones();
    // Strefa lokalna z systemu, a nie zgadywana z przesunięcia UTC:
    // przypomnienie „o 19:00" ma przyjść o 19:00 także po zmianie czasu
    // na zimowy, a samo przesunięcie tej informacji nie niesie.
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Nieznana nazwa strefy — zostaje UTC. Przypomnienia i tak zadziałają,
      // tylko mogą być przesunięte; lepsze to niż wywalony start aplikacji.
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  /// Prosi o zgodę na powiadomienia (Android 13+).
  ///
  /// Na starszych Androidach zgoda jest domyślna i metoda zwraca true
  /// bez pokazywania czegokolwiek.
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    await init();

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  /// Kasuje wszystkie zaplanowane alarmy i planuje je od nowa
  /// na podstawie włączonych przypomnień.
  Future<void> rescheduleAll() async {
    if (!Platform.isAndroid) return;
    await init();

    await _plugin.cancelAll();
    for (final reminder in await _dao.enabled()) {
      await _schedule(reminder);
    }
  }

  Future<void> _schedule(Reminder reminder) async {
    final days = parseWeekdays(reminder.weekdays);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Przypomnienia o ćwiczeniach i celach',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
    );

    if (days.isEmpty) {
      await _plugin.zonedSchedule(
        id: _notificationId(reminder.id, 0),
        title: reminder.title,
        body: reminder.body,
        scheduledDate: _nextInstanceOf(reminder.minuteOfDay),
        notificationDetails: details,
        // Nieprecyzyjny alarm celowo: tryb dokładny wymaga osobnego
        // uprawnienia SCHEDULE_EXACT_ALARM, a przy przypomnieniu
        // o ćwiczeniu kilka minut różnicy nie ma żadnego znaczenia.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: reminder.id,
      );
      return;
    }

    // Jedno powiadomienie na dzień tygodnia — system nie umie powtarzać
    // „w poniedziałki i środy" jednym wpisem.
    for (final weekday in days) {
      await _plugin.zonedSchedule(
        id: _notificationId(reminder.id, weekday),
        title: reminder.title,
        body: reminder.body,
        scheduledDate: _nextInstanceOfWeekday(reminder.minuteOfDay, weekday),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: reminder.id,
      );
    }
  }

  Future<void> cancelFor(String reminderId) async {
    if (!Platform.isAndroid) return;
    await init();

    // Kasujemy wszystkie warianty — codzienny plus siedem dni tygodnia —
    // bo nie wiadomo, w którym trybie przypomnienie było zaplanowane
    // przed edycją.
    for (var weekday = 0; weekday <= 7; weekday++) {
      await _plugin.cancel(id: _notificationId(reminderId, weekday));
    }
  }

  /// Stabilny identyfikator liczbowy z UUID przypomnienia.
  ///
  /// System przyjmuje tylko 32-bitowe inty, a wiersze mają UUID-y.
  /// Skrót z nazwy plus numer dnia tygodnia daje wartość powtarzalną
  /// między uruchomieniami, więc przeplanowanie trafia w te same alarmy
  /// zamiast tworzyć duplikaty.
  static int _notificationId(String reminderId, int weekday) {
    final hash = reminderId.hashCode & 0x00FFFFFF;
    return hash * 10 + weekday;
  }

  static tz.TZDateTime _nextInstanceOf(int minuteOfDay) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      minuteOfDay ~/ 60,
      minuteOfDay % 60,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static tz.TZDateTime _nextInstanceOfWeekday(int minuteOfDay, int weekday) {
    var scheduled = _nextInstanceOf(minuteOfDay);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

import 'dart:io';

import 'package:flutter/services.dart';

import '../db/daos/reminder_dao.dart';
import '../db/database.dart';

/// Powiadomienia z przypomnieniami o ćwiczeniach.
///
/// Oparte o własną implementację natywną (`Reminders.kt`, `AlarmManager`),
/// a nie o `flutter_local_notifications`. Tamta biblioteka ciągnie
/// implementację dla Windowsa wymagającą nagłówków ATL, których nie ma
/// w Visual Studio Build Tools — przez co psuła build aplikacji desktopowej.
/// Przypomnienia i tak są funkcją telefonu, więc zależność kosztowała
/// więcej, niż dawała.
///
/// Źródłem prawdy jest tabela `reminders`, a zaplanowane alarmy to tylko jej
/// odbicie w systemie. Android kasuje wszystkie zaplanowane powiadomienia
/// przy restarcie telefonu i przy aktualizacji aplikacji, więc
/// [rescheduleAll] leci przy każdym starcie — a po stronie natywnej
/// dodatkowo czuwa odbiornik `ReminderBootReceiver`.
class NotificationService {
  NotificationService(this._db);

  static const _channel = MethodChannel('tempo/reminders');

  final AppDatabase _db;

  ReminderDao get _dao => _db.reminderDao;

  /// Czy aplikacja ma zgodę na wyświetlanie powiadomień.
  ///
  /// Przed Androidem 13 zgoda była domyślna i strona natywna zwraca true
  /// bez pokazywania czegokolwiek.
  Future<bool> hasPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('hasPermission') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Prosi o zgodę i zwraca jej stan po prośbie.
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('requestPermission') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Kasuje wszystkie zaplanowane alarmy i planuje je od nowa
  /// na podstawie włączonych przypomnień.
  ///
  /// Pełne odtworzenie zamiast różnicowania: stan i tak trzeba umieć
  /// odbudować po restarcie, więc jedna droga jest prostsza i mniej
  /// podatna na rozjazd niż dwie.
  Future<void> rescheduleAll() async {
    if (!Platform.isAndroid) return;

    try {
      final reminders = await _dao.enabled();
      await _channel.invokeMethod<void>('reschedule', {
        'reminders': [
          for (final r in reminders)
            {
              'id': r.id,
              'title': r.title,
              'body': r.body,
              'minuteOfDay': r.minuteOfDay,
              // Konwencja `DateTime`: poniedziałek = 1. Przeliczenie na
              // androidowy `Calendar` dzieje się po stronie natywnej,
              // żeby tu nie trzymać dwóch numeracji naraz.
              'weekdays': parseWeekdays(r.weekdays),
            },
        ],
      });
    } on PlatformException {
      // Brak zaplanowanych alarmów jest zły, ale nie jest powodem,
      // żeby wywalić start aplikacji.
    }
  }

  Future<void> cancelAll() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('cancelAll');
    } on PlatformException {
      // jw.
    }
  }
}

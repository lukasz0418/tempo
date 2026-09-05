import 'dart:io';

import 'package:flutter/services.dart';

import '../db/enums.dart';
import 'activity_tracker.dart';

/// Import użycia aplikacji z androidowego `UsageStatsManager`.
///
/// Kluczowa różnica wobec Windowsa: system oddaje zdarzenia **wstecz**,
/// więc nie trzeba trzymać usługi w tle ani prosić o wyłączenie
/// optymalizacji baterii. Aplikacja może spać cały dzień i przy najbliższym
/// otwarciu dociągnąć komplet danych.
///
/// Kosztem jest to, że dostajemy wyłącznie nazwę pakietu — bez tytułu okna.
/// `com.android.chrome` nie powie, czy czytałeś dokumentację, czy Reddita.
/// Ta rozdzielczość jest do odzyskania tylko przez usługi dostępności,
/// a te czytają zawartość każdego ekranu — cena nieproporcjonalna
/// do zysku w prywatnej aplikacji.
class AndroidUsageTracker implements IntervalTracker {
  static const _channel = MethodChannel('tempo/usage');

  @override
  DevicePlatform get platform => DevicePlatform.android;

  @override
  Future<bool> isAvailable() async => Platform.isAndroid;

  @override
  Future<bool> hasPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('hasPermission') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Otwiera systemowe ustawienia „Dostęp do danych o użyciu".
  ///
  /// Tego uprawnienia nie da się przyznać zwykłym dialogiem — użytkownik
  /// musi wejść w ustawienia i włączyć je ręcznie. Ekran onboardingu
  /// powinien to uprzedzić, bo inaczej wygląda jak zgubienie się aplikacji.
  @override
  Future<void> requestPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('requestPermission');
    } on PlatformException {
      // Brak ekranu ustawień na tym urządzeniu — nic sensownego
      // nie da się zrobić, poza nieprzerywaniem działania aplikacji.
    }
  }

  @override
  Future<List<UsageInterval>> intervals(DateTime from, DateTime to) async {
    if (!Platform.isAndroid) return const [];

    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>(
        'queryIntervals',
        <String, Object>{
          'from': from.millisecondsSinceEpoch,
          'to': to.millisecondsSinceEpoch,
        },
      );
      if (raw == null) return const [];

      return raw
          .map((row) {
            final pkg = row['packageId'] as String?;
            final start = row['start'] as int?;
            final end = row['end'] as int?;
            if (pkg == null || start == null || end == null) return null;

            return UsageInterval(
              appId: pkg,
              appName: (row['label'] as String?) ?? pkg,
              start: DateTime.fromMillisecondsSinceEpoch(start),
              end: DateTime.fromMillisecondsSinceEpoch(end),
            );
          })
          .whereType<UsageInterval>()
          .toList();
    } on PlatformException {
      return const [];
    }
  }
}

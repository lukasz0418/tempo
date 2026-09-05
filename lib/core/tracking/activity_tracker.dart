import '../db/enums.dart';

/// Co jest w tej chwili na pierwszym planie.
class ForegroundInfo {
  const ForegroundInfo({
    required this.appId,
    required this.appName,
    this.windowTitle,
    this.idleFor = Duration.zero,
  });

  /// `chrome.exe` albo `com.google.android.youtube`.
  final String appId;

  /// Nazwa czytelna dla człowieka.
  final String appName;

  final String? windowTitle;

  /// Jak długo nie było żadnego inputu.
  ///
  /// Bez tego edytor zostawiony na noc zapisałby osiem godzin „produktywnej
  /// pracy" i cała statystyka poszłaby do kosza.
  final Duration idleFor;
}

/// Źródło danych o aktywności. Dwie implementacje o zupełnie różnym
/// charakterze, dlatego interfejs jest celowo wąski:
///
///  * Windows — odpytywanie na żywo, aplikacja musi być uruchomiona;
///  * Android — import wsteczny z `UsageStatsManager`, działa też za czas,
///    gdy aplikacja w ogóle nie chodziła.
abstract interface class ActivityTracker {
  DevicePlatform get platform;

  /// Czy da się w ogóle zbierać dane (uprawnienia, wsparcie systemu).
  Future<bool> isAvailable();

  /// Czy użytkownik nadał wymagane uprawnienia.
  Future<bool> hasPermission();

  /// Otwiera systemowy ekran nadawania uprawnień. Na Windowsie no-op.
  Future<void> requestPermission();
}

/// Tracker odpytywany na bieżąco (Windows).
abstract interface class PollingTracker implements ActivityTracker {
  /// Bieżący stan pierwszego planu; null, gdy nie da się go ustalić
  /// (ekran blokady, okno bez tytułu, brak uprawnień do procesu).
  Future<ForegroundInfo?> current();
}

/// Tracker importujący przedziały wstecz (Android).
abstract interface class IntervalTracker implements ActivityTracker {
  /// Przedziały użycia aplikacji w zadanym oknie czasu.
  Future<List<UsageInterval>> intervals(DateTime from, DateTime to);
}

class UsageInterval {
  const UsageInterval({
    required this.appId,
    required this.appName,
    required this.start,
    required this.end,
  });

  final String appId;
  final String appName;
  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);
}

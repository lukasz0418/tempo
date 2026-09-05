import 'dart:async';
import 'dart:io';

import '../db/daos/app_usage_dao.dart';
import '../db/daos/rule_dao.dart';
import '../db/daos/settings_dao.dart';
import '../db/database.dart';
import '../db/enums.dart';
import 'activity_tracker.dart';
import 'android_usage.dart';
import 'rule_engine.dart';
import 'windows_foreground.dart';

/// Spina pomiar aktywności: odpytuje system, przepuszcza wynik przez reguły
/// i zapisuje do bazy.
///
/// Obie platformy trafiają do tej samej tabeli, ale docierają tam zupełnie
/// inaczej. Windows odpytuje na żywo co [_pollInterval] i dokleja próbki do
/// trwającego bloku. Android nic nie odpytuje na bieżąco — przy każdym
/// wznowieniu aplikacji dociąga z systemu gotowe odcinki za czas, gdy jej
/// nie było.
class TrackingService {
  TrackingService({
    required AppDatabase db,
    PollingTracker? windowsTracker,
    IntervalTracker? androidTracker,
  })  :
        // Analizator proponuje `this._db`, ale Dart nie dopuszcza prywatnej
        // nazwy parametru nazwanego, a publiczne `db` w API jest czytelniejsze
        // niż upublicznienie pola.
        // ignore: prefer_initializing_formals
        _db = db,
        _windows = windowsTracker ??
            (Platform.isWindows ? WindowsForegroundReader() : null),
        _android =
            androidTracker ?? (Platform.isAndroid ? AndroidUsageTracker() : null);

  /// Co ile sekund sprawdzamy aktywne okno.
  ///
  /// Pięć sekund to kompromis: rzadziej gubi krótkie zerknięcia w Discorda,
  /// częściej obciąża procesor bez zysku w danych, na których i tak
  /// operujemy w skali minut.
  static const _pollInterval = Duration(seconds: 5);

  /// Po tylu sekundach bez ruchu myszy i klawiatury blok jest oznaczany
  /// jako bezczynny i nie liczy się do żadnej statystyki.
  static const _defaultIdleThreshold = 180;

  final AppDatabase _db;
  final PollingTracker? _windows;
  final IntervalTracker? _android;

  Timer? _timer;
  RuleEngine _engine = RuleEngine(const []);
  StreamSubscription<List<Rule>>? _rulesSub;
  String _deviceId = '';
  int _idleThreshold = _defaultIdleThreshold;

  AppUsageDao get _usage => _db.appUsageDao;
  RuleDao get _rules => _db.ruleDao;
  SettingsDao get _settings => _db.settingsDao;

  bool get isRunning => _timer != null;

  DevicePlatform get platform {
    if (Platform.isWindows) return DevicePlatform.windows;
    if (Platform.isAndroid) return DevicePlatform.android;
    return DevicePlatform.unknown;
  }

  Future<void> start() async {
    if (isRunning) return;

    _deviceId = await _settings.ensureDeviceId(platform, deviceName());
    _idleThreshold = await _settings.getInt(
      SettingKeys.idleThresholdSeconds,
      _defaultIdleThreshold,
    );

    // Silnik przebudowuje się sam, gdy zmienią się reguły — inaczej
    // po dodaniu reguły trzeba by restartować aplikację, żeby zaczęła działać.
    _rulesSub = _rules.watchEngineRules().listen((rules) {
      _engine = RuleEngine(rules);
    });
    _engine = RuleEngine(await _rules.engineRules());

    if (_windows != null && await _windows.isAvailable()) {
      _timer = Timer.periodic(_pollInterval, (_) => _tick());
      unawaited(_tick());
    }

    await importAndroidUsage();
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    await _rulesSub?.cancel();
    _rulesSub = null;
  }

  Future<void> _tick() async {
    final tracker = _windows;
    if (tracker == null) return;

    try {
      final info = await tracker.current();
      if (info == null) return;

      final idle = info.idleFor.inSeconds >= _idleThreshold;
      final result = _engine.classify(ActivitySample(
        appId: info.appId,
        windowTitle: info.windowTitle,
        platform: platform,
      ));

      await _usage.record(
        deviceId: _deviceId,
        platform: platform,
        appId: info.appId,
        appName: info.appName,
        windowTitle: info.windowTitle,
        at: DateTime.now().toUtc(),
        sampleLength: _pollInterval,
        productivity: result.productivity,
        ruleId: result.ruleId,
        categoryId: result.categoryId,
        idle: idle,
      );
    } catch (_) {
      // Pomiar w tle nie ma prawa ubić aplikacji. Pojedynczy nieudany odczyt
      // (zamykające się okno, proces bez praw dostępu) po prostu przepada —
      // przy próbce co 5 sekund strata jest niemierzalna.
    }
  }

  /// Dociąga z Androida użycie od ostatniego importu.
  ///
  /// Wołane przy starcie i przy każdym powrocie aplikacji na wierzch.
  /// Okno importu cofa się o dobę wstecz od ostatniego znanego punktu,
  /// bo zdarzenia bywają dopisywane z opóźnieniem; duplikaty odsiewa
  /// [AppUsageDao.insertInterval].
  Future<int> importAndroidUsage() async {
    final tracker = _android;
    if (tracker == null) return 0;
    if (!await tracker.isAvailable()) return 0;
    if (!await tracker.hasPermission()) return 0;

    final lastRaw = await _settings.get(_lastImportKey);
    final now = DateTime.now();
    final from = lastRaw == null
        ? now.subtract(const Duration(days: 7))
        : (DateTime.tryParse(lastRaw) ?? now.subtract(const Duration(days: 1)))
            .subtract(const Duration(days: 1));

    final intervals = await tracker.intervals(from, now);
    for (final i in intervals) {
      final result = _engine.classify(ActivitySample(
        appId: i.appId,
        platform: DevicePlatform.android,
      ));
      await _usage.insertInterval(
        deviceId: _deviceId,
        platform: DevicePlatform.android,
        appId: i.appId,
        appName: i.appName,
        startedAt: i.start,
        endedAt: i.end,
        productivity: result.productivity,
        ruleId: result.ruleId,
        categoryId: result.categoryId,
      );
    }

    await _settings.set(_lastImportKey, now.toIso8601String());
    return intervals.length;
  }

  /// Przelicza klasyfikację wszystkich niepotwierdzonych bloków
  /// aktualnym zestawem reguł. Zwraca liczbę zmienionych.
  Future<int> reclassifyAll() async {
    _engine = RuleEngine(await _rules.engineRules());
    return _usage.reclassifyUnreviewed((row) {
      return _engine
          .classify(ActivitySample(
            appId: row.appId,
            windowTitle: row.windowTitle,
            platform: row.platform,
          ))
          .productivity;
    });
  }

  static const _lastImportKey = 'android_usage_last_import';

  /// Nazwa tego urządzenia, widoczna w komunikatach typu
  /// „stoper chodzi od 3 h na *Pixelu*".
  ///
  /// Publiczna i statyczna, bo ustala ją też provider identyfikatora
  /// urządzenia. Dwie osobne implementacje potrafiłyby nadać temu samemu
  /// urządzeniu dwie różne nazwy, zależnie od tego, co odpaliło się pierwsze.
  static String deviceName() {
    if (Platform.isWindows) return Platform.localHostname;
    if (Platform.isAndroid) return 'Android';
    return 'Nieznane urządzenie';
  }
}

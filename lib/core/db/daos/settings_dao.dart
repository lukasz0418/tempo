import 'package:drift/drift.dart';

import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'settings_dao.g.dart';

/// Klucze ustawień lokalnych. Stałe, żeby literówka nie tworzyła
/// po cichu nowego, pustego ustawienia.
abstract final class SettingKeys {
  static const deviceId = 'device_id';
  static const deviceName = 'device_name';
  static const lastSyncedAt = 'last_synced_at';
  static const trackingEnabled = 'tracking_enabled';
  static const idleThresholdSeconds = 'idle_threshold_seconds';
  static const dailyAvailableMinutes = 'daily_available_minutes';

  /// Adres manifestu JSON z informacją o najnowszym wydaniu.
  /// Konfigurowalny, bo aplikacja nie musi wiedzieć, co go hostuje —
  /// GitHub Releases, własny serwer albo tunel do PC działają tak samo.
  static const updateManifestUrl = 'update_manifest_url';
  static const lastUpdateCheckAt = 'last_update_check_at';
}

@DriftAccessor(tables: [LocalSettings, Devices])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> get(String key) async {
    final row = await (select(localSettings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) {
    return into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<int> getInt(String key, int fallback) async {
    final raw = await get(key);
    return raw == null ? fallback : (int.tryParse(raw) ?? fallback);
  }

  Future<bool> getBool(String key, {bool fallback = false}) async {
    final raw = await get(key);
    return raw == null ? fallback : raw == 'true';
  }

  Future<void> setBool(String key, {required bool value}) =>
      set(key, value ? 'true' : 'false');

  Stream<String?> watch(String key) {
    return (select(localSettings)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }

  /// Zwraca identyfikator tego urządzenia, tworząc go przy pierwszym użyciu.
  ///
  /// Trzymany w [LocalSettings], które **nie podlegają synchronizacji** —
  /// gdyby `device_id` pojechało na serwer i wróciło na drugie urządzenie,
  /// oba nazywałyby się tak samo i wykrywanie zapomnianego stopera
  /// przestałoby działać.
  Future<String> ensureDeviceId(DevicePlatform platform, String name) async {
    final existing = await get(SettingKeys.deviceId);
    if (existing != null) {
      await _touchDevice(existing, platform, name);
      return existing;
    }

    final id = SyncStamp.newId();
    await set(SettingKeys.deviceId, id);
    await set(SettingKeys.deviceName, name);
    await _touchDevice(id, platform, name);
    return id;
  }

  Future<void> _touchDevice(
      String id, DevicePlatform platform, String name) async {
    final now = SyncStamp.now();
    await into(devices).insertOnConflictUpdate(
      DevicesCompanion.insert(
        id: id,
        name: name,
        platform: platform,
        lastSeenAt: now,
        createdAt: now,
        updatedAt: now,
        dirty: const Value(true),
      ),
    );
  }

  Future<DateTime?> lastSyncedAt() async {
    final raw = await get(SettingKeys.lastSyncedAt);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setLastSyncedAt(DateTime value) =>
      set(SettingKeys.lastSyncedAt, value.toUtc().toIso8601String());
}

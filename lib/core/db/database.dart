import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'daos/app_usage_dao.dart';
import 'daos/idea_dao.dart';
import 'daos/insight_dao.dart';
import 'daos/rule_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/task_dao.dart';
import 'daos/time_entry_dao.dart';
// Wygenerowany `database.g.dart` jest częścią tego pliku i odwołuje się
// do enumów bezpośrednio. Import przez `tables.dart` tu nie wystarczy —
// dla plików `part` widoczność importów nie jest przechodnia.
import 'enums.dart';
import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Tasks,
    TimeEntries,
    AppUsages,
    ActivityRules,
    Ideas,
    DayPlans,
    Devices,
    LocalSettings,
  ],
  daos: [
    TaskDao,
    TimeEntryDao,
    AppUsageDao,
    RuleDao,
    IdeaDao,
    InsightDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  /// Konstruktor dla testów — pozwala wstrzyknąć bazę w pamięci.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDatabase(this);
        },
        beforeOpen: (details) async {
          // Klucze obce są w SQLite domyślnie wyłączone i trzeba je włączać
          // przy każdym połączeniu, nie raz przy tworzeniu bazy.
          await customStatement('PRAGMA foreign_keys = ON');

          if (details.wasCreated) return;

          // Seed reguł wbudowanych jest idempotentny: dokłada tylko te,
          // których jeszcze nie ma. Dzięki temu nowe reguły z aktualizacji
          // aplikacji trafiają do istniejącej bazy, a wyłączone przez
          // użytkownika nie wracają zombie.
          await seedBuiltinRules(this);
        },
      );
}

QueryExecutor _open() {
  return driftDatabase(
    name: 'tempo',
    native: DriftNativeOptions(
      // WAL — pomiar w tle dopisuje próbki aktywności w tym samym czasie,
      // gdy UI czyta statystyki. Bez tego czytelnik blokuje pisarza.
      shareAcrossIsolates: true,

      // Domyślnie drift kładzie plik w katalogu Dokumentów. Na Windowsie
      // to katalog widoczny dla użytkownika i często objęty synchronizacją
      // OneDrive — a synchronizowany plik SQLite (z osobnymi plikami -wal
      // i -shm) prędzej czy później kończy się uszkodzoną bazą.
      // Katalog danych aplikacji nie jest synchronizowany.
      databaseDirectory: () async {
        final dir = await getApplicationSupportDirectory();
        return dir.path;
      },
    ),
  );
}

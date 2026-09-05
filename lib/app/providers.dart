import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/db/daos/app_usage_dao.dart';
import '../core/db/daos/goal_dao.dart';
import '../core/db/daos/idea_dao.dart';
import '../core/db/daos/insight_dao.dart';
import '../core/db/daos/journal_dao.dart';
import '../core/db/daos/reminder_dao.dart';
import '../core/db/daos/rule_dao.dart';
import '../core/db/daos/settings_dao.dart';
import '../core/db/daos/skill_dao.dart';
import '../core/db/daos/task_dao.dart';
import '../core/db/daos/time_entry_dao.dart';
import '../core/db/database.dart';
import '../core/db/enums.dart';
import '../core/estimation/estimation.dart';
import '../core/media/media_capture.dart';
import '../core/media/media_store.dart';
import '../core/notifications/notification_service.dart';
import '../core/review/day_review.dart';
import '../core/tracking/tracking_service.dart';
import '../core/update/update_service.dart';
import '../core/util/dates.dart';

/// Providery są pisane ręcznie, bez `riverpod_generator`.
///
/// Generator w wersji zgodnej z Riverpodem 3 ciągnie za sobą `custom_lint`
/// i `analyzer` w wersjach, które kłócą się z resztą zależności. Przy tej
/// liczbie providerów codegen i tak nie oszczędza pracy, a dokłada
/// drugi krok budowania.

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final taskDaoProvider = Provider<TaskDao>((ref) => ref.watch(databaseProvider).taskDao);
final timeEntryDaoProvider =
    Provider<TimeEntryDao>((ref) => ref.watch(databaseProvider).timeEntryDao);
final appUsageDaoProvider =
    Provider<AppUsageDao>((ref) => ref.watch(databaseProvider).appUsageDao);
final ruleDaoProvider = Provider<RuleDao>((ref) => ref.watch(databaseProvider).ruleDao);
final ideaDaoProvider = Provider<IdeaDao>((ref) => ref.watch(databaseProvider).ideaDao);
final insightDaoProvider =
    Provider<InsightDao>((ref) => ref.watch(databaseProvider).insightDao);
final settingsDaoProvider =
    Provider<SettingsDao>((ref) => ref.watch(databaseProvider).settingsDao);

final trackingServiceProvider = Provider<TrackingService>((ref) {
  final service = TrackingService(db: ref.watch(databaseProvider));
  ref.onDispose(service.stop);
  return service;
});

/// Identyfikator tego urządzenia. Potrzebny przy każdym zapisie wpisu czasu.
final deviceIdProvider = FutureProvider<String>((ref) async {
  final settings = ref.watch(settingsDaoProvider);
  final tracking = ref.watch(trackingServiceProvider);
  return settings.ensureDeviceId(
    tracking.platform,
    TrackingService.deviceName(),
  );
});

/// Dzień oglądany w widokach „Dziś" i „Podsumowanie".
///
/// Riverpod 3 nie ma już `StateProvider`, więc prosty stan trzyma
/// [Notifier] z jawnymi metodami. Wychodzi na tym lepiej: przesuwanie dnia
/// jest operacją domenową, a nie przypisaniem do publicznego pola.
class SelectedDay extends Notifier<DateTime> {
  @override
  DateTime build() => startOfDay(DateTime.now());

  void set(DateTime day) => state = startOfDay(day);

  void shift(int days) => state = state.add(Duration(days: days));

  void today() => state = startOfDay(DateTime.now());
}

final selectedDayProvider =
    NotifierProvider<SelectedDay, DateTime>(SelectedDay.new);

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.categories)
        ..where((c) => c.deleted.equals(false) & c.archived.equals(false))
        ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]))
      .watch();
});

/// Mapa id → kategoria, żeby UI nie robił wyszukiwania liniowego
/// przy renderowaniu każdego wiersza listy.
final categoryMapProvider = Provider<Map<String, Category>>((ref) {
  final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
  return {for (final c in cats) c.id: c};
});

final runningEntryProvider = StreamProvider<TimeEntry?>((ref) {
  return ref.watch(timeEntryDaoProvider).watchRunningRaw();
});

final openTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskDaoProvider).watchOpen();
});

final todayEntriesProvider = StreamProvider<List<TimeEntry>>((ref) {
  final day = ref.watch(selectedDayProvider);
  return ref.watch(timeEntryDaoProvider).watchForDay(day);
});

final dayUsageProvider = StreamProvider<List<AppUsage>>((ref) {
  final day = ref.watch(selectedDayProvider);
  return ref.watch(appUsageDaoProvider).watchForDay(day);
});

final unclassifiedUsageProvider = StreamProvider<List<AppUsage>>((ref) {
  return ref.watch(appUsageDaoProvider).watchUnclassified();
});

final openIdeasProvider = StreamProvider<List<Idea>>((ref) {
  return ref.watch(ideaDaoProvider).watchOpen();
});

final allIdeasProvider = StreamProvider<List<Idea>>((ref) {
  return ref.watch(ideaDaoProvider).watchAll();
});

/// Skasowane pomysły — możliwe do odzyskania, bo kasowanie jest miękkie.
final deletedIdeasProvider = StreamProvider<List<Idea>>((ref) {
  return ref.watch(ideaDaoProvider).watchDeleted();
});

final rulesProvider = StreamProvider<List<ActivityRule>>((ref) {
  return ref.watch(ruleDaoProvider).watchAll();
});

/// Statystyka trafności estymat — globalna, ze wszystkich zamkniętych zadań.
final estimateStatsProvider = FutureProvider<EstimateStats>((ref) async {
  final samples = await ref.watch(insightDaoProvider).estimateSamples();
  return Estimator.stats(samples);
});

/// Podział czasu w wybranym dniu.
///
/// Zależy od [dayUsageProvider], żeby przeliczał się sam, gdy pomiar
/// w tle dopisze nowe próbki — bez tego statystyki stoją, dopóki
/// nie przełączysz ekranu.
final dayProductivityProvider =
    FutureProvider<Map<Productivity, Duration>>((ref) async {
  ref.watch(dayUsageProvider);
  final day = ref.watch(selectedDayProvider);
  return ref
      .watch(insightDaoProvider)
      .productivitySplit(startOfDay(day), endOfDay(day));
});

/// Komplet liczb o dniu, na których opiera się podsumowanie.
final dayFactsProvider = FutureProvider<DayFacts>((ref) async {
  ref.watch(dayUsageProvider);
  ref.watch(todayEntriesProvider);

  final day = ref.watch(selectedDayProvider);
  final insights = ref.watch(insightDaoProvider);
  final usage = ref.watch(appUsageDaoProvider);
  final key = dayKey(day);

  final split =
      await insights.productivitySplit(startOfDay(day), endOfDay(day));
  final completed = await insights.tasksCompletedOn(day);
  final planned = await insights.tasksPlannedFor(key);
  final plan = await insights.dayPlan(key);

  final topApps =
      await usage.topApps(startOfDay(day), endOfDay(day), limit: 20);
  final worstDistraction = topApps
      .where((a) => a.productivity == Productivity.distraction)
      .fold<({String appName, Duration total})?>(null, (best, a) {
    if (best == null || a.total > best.total) {
      return (appName: a.appName, total: a.total);
    }
    return best;
  });

  var plannedWork = Duration.zero;
  for (final t in planned) {
    final lo = t.estimateMinSeconds;
    final hi = t.estimateMaxSeconds ?? lo;
    if (lo == null || hi == null) continue;
    plannedWork += Duration(seconds: (lo + hi) ~/ 2);
  }

  return DayFacts(
    day: day,
    split: split,
    tracked: await insights.trackedTimeOn(day),
    tasksCompleted: completed.length,
    tasksPlanned: planned.length,
    longestFocus: await insights.longestFocusBlock(day),
    distractionSwitches: await insights.distractionSwitches(day),
    topDistraction: worstDistraction == null
        ? null
        : (name: worstDistraction.appName, time: worstDistraction.total),
    estimateStats: await ref.watch(estimateStatsProvider.future),
    availableMinutes: plan?.availableMinutes,
    plannedWork: plannedWork,
  );
});

/// Werdykt dnia — co poszło dobrze, a co nie.
final dayVerdictProvider = FutureProvider<DayVerdict>((ref) async {
  final facts = await ref.watch(dayFactsProvider.future);
  return DayReviewer.analyze(facts);
});

final dayPlanProvider = FutureProvider<DayPlan?>((ref) async {
  final day = ref.watch(selectedDayProvider);
  return ref.watch(insightDaoProvider).dayPlan(dayKey(day));
});

// --- umiejętności i dziennik -------------------------------------------

final skillDaoProvider =
    Provider<SkillDao>((ref) => ref.watch(databaseProvider).skillDao);
final journalDaoProvider =
    Provider<JournalDao>((ref) => ref.watch(databaseProvider).journalDao);

final skillsProvider = StreamProvider<List<Skill>>((ref) {
  return ref.watch(skillDaoProvider).watchActive();
});

final allSkillsProvider = StreamProvider<List<Skill>>((ref) {
  return ref.watch(skillDaoProvider).watchAll();
});

/// Postęp w umiejętności.
///
/// Zależy od strumienia wpisów dziennika i od wpisów czasu, więc przelicza
/// się sam po zamknięciu sesji — bez tego statystyki stoją, dopóki
/// nie przełączysz ekranu.
final skillProgressProvider =
    FutureProvider.family<SkillProgress, String>((ref, skillId) async {
  ref.watch(journalEntriesProvider(skillId));
  ref.watch(runningEntryProvider);
  return ref.watch(skillDaoProvider).progress(skillId);
});

final journalEntriesProvider =
    StreamProvider.family<List<JournalEntry>, String>((ref, skillId) {
  return ref.watch(journalDaoProvider).watchForSkill(skillId);
});

final journalPageProvider =
    StreamProvider.family<JournalPage?, String>((ref, entryId) {
  return ref.watch(journalDaoProvider).watchPage(entryId);
});

final attachmentsProvider =
    StreamProvider.family<List<Attachment>, String>((ref, entryId) {
  return ref.watch(journalDaoProvider).watchAttachments(entryId);
});

// --- cele ----------------------------------------------------------------

final goalDaoProvider =
    Provider<GoalDao>((ref) => ref.watch(databaseProvider).goalDao);

final skillGoalsProvider =
    StreamProvider.family<List<Goal>, String>((ref, skillId) {
  return ref.watch(goalDaoProvider).watchForSkill(skillId);
});

final activeGoalsProvider = StreamProvider<List<Goal>>((ref) {
  return ref.watch(goalDaoProvider).watchActive();
});

/// Postęp celu. Zależy od trwającego pomiaru, więc odświeża się sam
/// po zatrzymaniu stopera.
final goalProgressProvider =
    FutureProvider.family<GoalProgress, String>((ref, goalId) async {
  ref.watch(runningEntryProvider);
  final dao = ref.watch(goalDaoProvider);
  final goal = await dao.byId(goalId);
  if (goal == null) {
    return const GoalProgress(
      current: 0,
      target: 1,
      metric: GoalMetric.custom,
    );
  }
  return dao.progress(goal);
});

// --- przypomnienia -------------------------------------------------------

final reminderDaoProvider =
    Provider<ReminderDao>((ref) => ref.watch(databaseProvider).reminderDao);

final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(reminderDaoProvider).watchAll();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(databaseProvider));
});

final mediaStoreProvider = FutureProvider<MediaStore>((ref) {
  return MediaStore.instance();
});

final mediaCaptureProvider = FutureProvider<MediaCapture>((ref) async {
  final store = await ref.watch(mediaStoreProvider.future);
  final capture = MediaCapture(store);
  ref.onDispose(capture.dispose);
  return capture;
});

final updateServiceProvider = Provider<UpdateService>((ref) {
  final service = UpdateService();
  ref.onDispose(service.dispose);
  return service;
});

/// Adres manifestu aktualizacji, obserwowany z bazy.
final updateManifestUrlProvider = StreamProvider<String?>((ref) {
  return ref.watch(settingsDaoProvider).watch(SettingKeys.updateManifestUrl);
});

/// Wynik ostatniego sprawdzenia aktualizacji.
///
/// Sprawdzenie jest jawną akcją użytkownika albo skutkiem powrotu aplikacji
/// na wierzch — celowo nie odpytujemy serwera w pętli w tle. Aplikacja do
/// pilnowania czasu nie powinna sama zjadać baterii.
final updateCheckProvider = FutureProvider<UpdateCheck?>((ref) async {
  final url = await ref.watch(updateManifestUrlProvider.future);
  if (url == null || url.isEmpty) return null;
  return ref.watch(updateServiceProvider).check(url);
});

import 'package:drift/drift.dart';

import 'database.dart';
import 'enums.dart';

/// Dane startowe: kategorie i wbudowane reguły klasyfikacji.
///
/// Identyfikatory rzeczy wbudowanych są **stałymi stringami**, nie UUID-ami
/// (`builtin.win.steam`, `cat.home`). Dzięki temu ponowne uruchomienie seeda
/// po aktualizacji aplikacji rozpoznaje, co już istnieje, i dokłada wyłącznie
/// nowe wiersze — bez duplikatów i bez wskrzeszania reguł, które wyłączyłeś.

const _kBuiltinPrefix = 'builtin.';

Future<void> seedDatabase(AppDatabase db) async {
  await _seedCategories(db);
  await seedBuiltinRules(db);
}

Future<void> _seedCategories(AppDatabase db) async {
  final now = DateTime.now();
  final rows = <CategoriesCompanion>[
    _cat('cat.work', 'Praca', 0xFF4C6EF5, Productivity.productive, 0, now),
    _cat('cat.learn', 'Nauka', 0xFF7950F2, Productivity.productive, 1, now),
    _cat('cat.home', 'Dom', 0xFF12B886, Productivity.productive, 2, now),
    _cat('cat.health', 'Zdrowie', 0xFFFA5252, Productivity.productive, 3, now),
    _cat('cat.admin', 'Sprawy', 0xFF868E96, Productivity.neutral, 4, now),
    _cat('cat.social', 'Ludzie', 0xFFFD7E14, Productivity.neutral, 5, now),
    _cat('cat.rest', 'Odpoczynek', 0xFF15AABF, Productivity.leisure, 6, now),
  ];

  await db.batch((b) {
    b.insertAllOnConflictUpdate(db.categories, rows);
  });
}

CategoriesCompanion _cat(
  String id,
  String name,
  int color,
  Productivity productivity,
  int order,
  DateTime now,
) {
  return CategoriesCompanion.insert(
    id: id,
    name: name,
    color: color,
    createdAt: now,
    updatedAt: now,
    defaultProductivity: Value(productivity),
    sortOrder: Value(order),
    // Kategorie wbudowane też muszą trafić na serwer, więc startują jako dirty.
    dirty: const Value(true),
  );
}

/// Dokłada brakujące reguły wbudowane. Idempotentne i bezpieczne
/// do wywołania przy każdym otwarciu bazy.
Future<void> seedBuiltinRules(AppDatabase db) async {
  final existing = await (db.select(db.activityRules)
        ..where((r) => r.id.like('$_kBuiltinPrefix%')))
      .map((r) => r.id)
      .get();
  final known = existing.toSet();

  final missing =
      _builtinRules().where((r) => !known.contains(r.id.value)).toList();
  if (missing.isEmpty) return;

  await db.batch((b) => b.insertAll(db.activityRules, missing));
}

/// Priorytety reguł — im wyżej, tym mocniej wiąże.
///
/// Tytuł okna bije nazwę aplikacji, bo to jedyny sposób, żeby odróżnić
/// przeglądarkę z dokumentacją od przeglądarki z YouTubem. Ta sama binarka,
/// zupełnie inny czas.
const _pTitle = 100;
const _pAppExact = 50;
const _pAppFamily = 30;

List<ActivityRulesCompanion> _builtinRules() {
  final now = DateTime.now();
  final out = <ActivityRulesCompanion>[];

  void rule(
    String id,
    String label,
    String pattern,
    Productivity productivity, {
    MatchTarget target = MatchTarget.appId,
    MatchType type = MatchType.contains,
    DevicePlatform? platform,
    int priority = _pAppExact,
    String? categoryId,
    bool enabled = true,
  }) {
    out.add(ActivityRulesCompanion.insert(
      id: '$_kBuiltinPrefix$id',
      pattern: pattern,
      productivity: productivity,
      createdAt: now,
      updatedAt: now,
      label: Value(label),
      matchTarget: Value(target),
      matchType: Value(type),
      platform: Value(platform),
      priority: Value(priority),
      categoryId: Value(categoryId),
      enabled: Value(enabled),
      isBuiltin: const Value(true),
    ));
  }

  // ---------------------------------------------------------------
  // Rozpraszacze rozpoznawane po tytule okna — działa dla każdej
  // przeglądarki naraz, więc nie trzeba wymieniać Chrome, Firefoxa i Edge.
  // ---------------------------------------------------------------
  rule('title.youtube', 'YouTube', 'YouTube', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.twitch', 'Twitch', 'Twitch', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.tiktok', 'TikTok', 'TikTok', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.reddit', 'Reddit', 'Reddit', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.insta', 'Instagram', 'Instagram', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.fb', 'Facebook', 'Facebook', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.x', 'X / Twitter', ' / X', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.netflix', 'Netflix', 'Netflix', Productivity.leisure,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');
  rule('title.wykop', 'Wykop', 'Wykop', Productivity.distraction,
      target: MatchTarget.windowTitle, priority: _pTitle, categoryId: 'cat.rest');

  // Materiały do nauki na YouTube. Wyłączona domyślnie, bo to wzorzec
  // do dopasowania pod siebie — pokazuje mechanizm: wyższy priorytet
  // wygrywa z regułą `title.youtube` powyżej.
  rule('title.youtube.learning', 'YouTube — materiały do nauki',
      r'(?i)(tutorial|kurs|course|dokumentacja|conf talk).*YouTube',
      Productivity.productive,
      target: MatchTarget.windowTitle,
      type: MatchType.regex,
      priority: _pTitle + 10,
      categoryId: 'cat.learn',
      enabled: false);

  // ---------------------------------------------------------------
  // Windows — aplikacje
  // ---------------------------------------------------------------
  const win = DevicePlatform.windows;

  for (final g in const [
    ('steam', 'Steam', 'steam.exe'),
    ('epic', 'Epic Games', 'EpicGamesLauncher.exe'),
    ('riot', 'Riot Client', 'RiotClientServices.exe'),
    ('lol', 'League of Legends', 'League of Legends.exe'),
    ('cs2', 'Counter-Strike 2', 'cs2.exe'),
    ('valorant', 'Valorant', 'VALORANT-Win64-Shipping.exe'),
    ('minecraft', 'Minecraft', 'javaw.exe'),
    ('battlenet', 'Battle.net', 'Battle.net.exe'),
    ('gog', 'GOG Galaxy', 'GalaxyClient.exe'),
    ('ubisoft', 'Ubisoft Connect', 'upc.exe'),
  ]) {
    rule('win.game.${g.$1}', g.$2, g.$3, Productivity.distraction,
        platform: win, categoryId: 'cat.rest');
  }

  rule('win.discord', 'Discord', 'Discord.exe', Productivity.leisure,
      platform: win, categoryId: 'cat.social');
  rule('win.spotify', 'Spotify', 'Spotify.exe', Productivity.neutral,
      platform: win, priority: _pAppFamily);

  for (final p in const [
    ('vscode', 'VS Code', 'Code.exe'),
    ('studio', 'Android Studio', 'studio64.exe'),
    ('idea', 'IntelliJ IDEA', 'idea64.exe'),
    ('terminal', 'Terminal', 'WindowsTerminal.exe'),
    ('pwsh', 'PowerShell', 'powershell.exe'),
    ('obsidian', 'Obsidian', 'Obsidian.exe'),
    ('figma', 'Figma', 'Figma.exe'),
  ]) {
    rule('win.prod.${p.$1}', p.$2, p.$3, Productivity.productive,
        platform: win, categoryId: 'cat.work');
  }

  for (final o in const [
    ('word', 'Word', 'WINWORD.EXE'),
    ('excel', 'Excel', 'EXCEL.EXE'),
    ('ppt', 'PowerPoint', 'POWERPNT.EXE'),
  ]) {
    rule('win.office.${o.$1}', o.$2, o.$3, Productivity.productive,
        platform: win, categoryId: 'cat.admin');
  }

  rule('win.explorer', 'Eksplorator plików', 'explorer.exe',
      Productivity.neutral,
      platform: win, priority: _pAppFamily);

  // ---------------------------------------------------------------
  // Android — pakiety
  // ---------------------------------------------------------------
  const droid = DevicePlatform.android;

  for (final d in const [
    ('youtube', 'YouTube', 'com.google.android.youtube'),
    ('twitch', 'Twitch', 'tv.twitch.android.app'),
    ('tiktok', 'TikTok', 'com.zhiliaoapp.musically'),
    ('insta', 'Instagram', 'com.instagram.android'),
    ('fb', 'Facebook', 'com.facebook.katana'),
    ('reddit', 'Reddit', 'com.reddit.frontpage'),
    ('x', 'X', 'com.twitter.android'),
    ('shorts', 'YouTube (druga apka)', 'com.google.android.apps.youtube'),
  ]) {
    rule('droid.distract.${d.$1}', d.$2, d.$3, Productivity.distraction,
        type: MatchType.startsWith,
        platform: droid,
        categoryId: 'cat.rest');
  }

  for (final d in const [
    ('netflix', 'Netflix', 'com.netflix.mediaclient'),
    ('hbo', 'HBO Max', 'com.wbd.stream'),
    ('disney', 'Disney+', 'com.disney.disneyplus'),
    ('discord', 'Discord', 'com.discord'),
    ('steam', 'Steam', 'com.valvesoftware.android.steam.community'),
  ]) {
    rule('droid.leisure.${d.$1}', d.$2, d.$3, Productivity.leisure,
        platform: droid, categoryId: 'cat.rest');
  }

  for (final d in const [
    ('duolingo', 'Duolingo', 'com.duolingo'),
    ('anki', 'AnkiDroid', 'com.ichi2.anki'),
    ('docs', 'Dokumenty Google', 'com.google.android.apps.docs'),
    ('kindle', 'Kindle', 'com.amazon.kindle'),
  ]) {
    rule('droid.prod.${d.$1}', d.$2, d.$3, Productivity.productive,
        platform: droid, categoryId: 'cat.learn');
  }

  rule('droid.spotify', 'Spotify', 'com.spotify.music', Productivity.neutral,
      platform: droid, priority: _pAppFamily);
  rule('droid.maps', 'Mapy', 'com.google.android.apps.maps',
      Productivity.neutral,
      platform: droid, priority: _pAppFamily);
  rule('droid.phone', 'Telefon', 'com.android.dialer', Productivity.neutral,
      platform: droid, priority: _pAppFamily);

  // Gry na Androidzie nie mają wspólnego prefiksu pakietu, więc łapiemy
  // tylko najpopularniejsze rodziny. Resztę dopisze się samemu jednym
  // kliknięciem z ekranu przeglądu — po to jest przycisk „zaklasyfikuj".
  for (final d in const [
    ('supercell', 'Gry Supercell', 'com.supercell.'),
    ('king', 'Gry King', 'com.king.'),
    ('roblox', 'Roblox', 'com.roblox.'),
    ('mojang', 'Minecraft', 'com.mojang.'),
  ]) {
    rule('droid.game.${d.$1}', d.$2, d.$3, Productivity.distraction,
        type: MatchType.startsWith,
        platform: droid,
        priority: _pAppFamily,
        categoryId: 'cat.rest');
  }

  return out;
}

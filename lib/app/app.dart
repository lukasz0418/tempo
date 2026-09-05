import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ideas/ideas_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/review/review_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/skills/skills_screen.dart';
import '../features/tasks/tasks_screen.dart';
import '../features/today/today_screen.dart';
import 'providers.dart';
import 'theme.dart';

class TempoApp extends StatelessWidget {
  const TempoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const _Shell(),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.builder, {String? navLabel})
      : navLabel = navLabel ?? label;

  /// Pełna nazwa, pokazywana w pasku tytułu.
  final String label;

  /// Nazwa w nawigacji. Bywa krótsza, bo pasek na dole telefonu dzieli
  /// szerokość na pięć — „Podsumowanie" łamie się tam na dwie linie
  /// i rozpycha cały pasek.
  final String navLabel;

  final IconData icon;
  final WidgetBuilder builder;
}

/// Pięć pozycji, nie sześć.
///
/// Pomysły i Ustawienia siedzą w pasku górnym, bo wchodzi się do nich
/// rzadko — a szósta zakładka na dolnym pasku telefonu odbiera miejsce
/// tym, których używa się codziennie.
final _destinations = <_Destination>[
  _Destination('Dziś', Icons.today, (_) => const TodayScreen()),
  _Destination('Zadania', Icons.check_circle_outline, (_) => const TasksScreen()),
  _Destination(
    'Umiejętności',
    Icons.trending_up,
    (_) => const SkillsScreen(),
    navLabel: 'Rozwój',
  ),
  _Destination('Statystyki', Icons.bar_chart, (_) => const InsightsScreen()),
  _Destination(
    'Podsumowanie dnia',
    Icons.nightlight_outlined,
    (_) => const ReviewScreen(),
    navLabel: 'Bilans',
  ),
];

class _Shell extends ConsumerStatefulWidget {
  const _Shell();

  @override
  ConsumerState<_Shell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<_Shell> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Pomiar startuje po pierwszej klatce, a nie w `initState` — inaczej
    // otwarcie bazy i odczyt reguł blokują pierwsze wyświetlenie okna.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trackingServiceProvider).start();

      // Android kasuje zaplanowane alarmy przy restarcie telefonu
      // i przy aktualizacji aplikacji, więc odtwarzamy je przy każdym
      // starcie. Bez tego przypomnienia po cichu przestają przychodzić
      // po pierwszym restarcie — najgorszy rodzaj awarii, bo niewidoczny.
      ref.read(notificationServiceProvider).rescheduleAll();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Powrót aplikacji na wierzch to moment, w którym Android ma gotowe
    // dane o tym, co działo się, gdy jej nie było.
    if (state == AppLifecycleState.resumed) {
      ref.read(trackingServiceProvider).importAndroidUsage();
      // Cele liczone automatycznie domykają się same — bez tego wisiałyby
      // jako aktywne mimo osiągnięcia progu i trzeba by je odhaczać ręcznie,
      // czyli dokładnie tak, jak nie chcieliśmy.
      ref.read(goalDaoProvider).refreshAchievements();
    }
  }

  @override
  Widget build(BuildContext context) {
    final destination = _destinations[_index];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Na szerokim ekranie szyna boczna, na wąskim pasek na dole.
        // Próg 720 px, bo poniżej pięć etykiet w szynie zjada połowę okna.
        final wide = constraints.maxWidth >= 720;

        final body = Scaffold(
          appBar: AppBar(
            title: Text(destination.label),
            actions: [
              IconButton(
                icon: const Icon(Icons.lightbulb_outline),
                tooltip: 'Pomysły',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Pomysły')),
                      body: const IdeasScreen(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Ustawienia',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Ustawienia')),
                      body: const SettingsScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: destination.builder(context),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: [
                    for (final d in _destinations)
                      NavigationDestination(
                          icon: Icon(d.icon), label: d.navLabel),
                  ],
                ),
        );

        if (!wide) return body;

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      // W szynie bocznej jest miejsce na pełną nazwę.
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}

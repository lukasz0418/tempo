import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ideas/ideas_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/review/review_screen.dart';
import '../features/settings/settings_screen.dart';
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
  const _Destination(this.label, this.icon, this.builder);

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}

final _destinations = <_Destination>[
  _Destination('Dziś', Icons.today, (_) => const TodayScreen()),
  _Destination('Zadania', Icons.check_circle_outline, (_) => const TasksScreen()),
  _Destination('Statystyki', Icons.bar_chart, (_) => const InsightsScreen()),
  _Destination('Podsumowanie', Icons.nightlight_outlined, (_) => const ReviewScreen()),
  _Destination('Pomysły', Icons.lightbulb_outline, (_) => const IdeasScreen()),
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
              // Ustawienia jako akcja w pasku, a nie szósta pozycja nawigacji —
              // sześć zakładek na dolnym pasku telefonu robi się nieczytelne,
              // a do ustawień i tak wchodzi się rzadko.
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
                      NavigationDestination(icon: Icon(d.icon), label: d.label),
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

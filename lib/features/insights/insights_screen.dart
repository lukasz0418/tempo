import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/db/enums.dart';
import '../../core/util/dates.dart';
import 'charts.dart';

/// Okno czasu, za które liczymy statystyki.
enum InsightRange {
  today('Dziś', 1),
  week('7 dni', 7),
  month('30 dni', 30);

  const InsightRange(this.label, this.days);

  final String label;
  final int days;
}

class InsightRangeNotifier extends Notifier<InsightRange> {
  @override
  InsightRange build() => InsightRange.week;

  void select(InsightRange range) => state = range;
}

final insightRangeProvider =
    NotifierProvider<InsightRangeNotifier, InsightRange>(
        InsightRangeNotifier.new);

final _rangeBoundsProvider = Provider<({DateTime from, DateTime to})>((ref) {
  final range = ref.watch(insightRangeProvider);
  final to = endOfDay(DateTime.now());
  return (from: to.subtract(Duration(days: range.days)), to: to);
});

final _heatmapProvider = FutureProvider<List<Duration>>((ref) async {
  ref.watch(dayUsageProvider);
  final bounds = ref.watch(_rangeBoundsProvider);
  return ref.watch(insightDaoProvider).hourlyHeatmap(
        bounds.from,
        bounds.to,
        only: Productivity.productive,
      );
});

final _topAppsProvider = FutureProvider<
    List<({String appId, String appName, Productivity productivity, Duration total})>>(
  (ref) async {
    ref.watch(dayUsageProvider);
    final bounds = ref.watch(_rangeBoundsProvider);
    return ref.watch(appUsageDaoProvider).topApps(bounds.from, bounds.to);
  },
);

final _rangeSplitProvider =
    FutureProvider<Map<Productivity, Duration>>((ref) async {
  ref.watch(dayUsageProvider);
  final bounds = ref.watch(_rangeBoundsProvider);
  return ref.watch(insightDaoProvider).productivitySplit(bounds.from, bounds.to);
});

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(insightRangeProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Filtry w jednym rzędzie nad wykresami.
        SegmentedButton<InsightRange>(
          segments: [
            for (final r in InsightRange.values)
              ButtonSegment(value: r, label: Text(r.label)),
          ],
          selected: {range},
          onSelectionChanged: (s) =>
              ref.read(insightRangeProvider.notifier).select(s.first),
        ),
        const SizedBox(height: 16),
        _Section(
          title: 'Podział czasu',
          subtitle: 'Produktywny kontra stracony, z automatycznego pomiaru.',
          child: ref.watch(_rangeSplitProvider).when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Błąd: $e'),
                data: (split) => ProductivityStackedBar(split: split),
              ),
        ),
        const SizedBox(height: 16),
        _Section(
          title: 'Kiedy realnie pracujesz',
          subtitle: 'Suma produktywnego czasu w każdej godzinie doby.',
          child: ref.watch(_heatmapProvider).when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Błąd: $e'),
                data: (buckets) => HourHeatmap(
                  buckets: buckets,
                  label: 'Godziny z produktywną pracą',
                ),
              ),
        ),
        const SizedBox(height: 16),
        _Section(
          title: 'Gdzie poszedł czas',
          child: ref.watch(_topAppsProvider).when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Błąd: $e'),
                data: (apps) => RankedBars(
                  rows: [
                    for (final a in apps)
                      (
                        label: a.appName.isEmpty ? a.appId : a.appName,
                        value: a.total,
                        // Tu kolor niesie klasyfikację, a nie wielkość —
                        // sens listy jest w tym, które pozycje są czerwone.
                        accent: VizColors.forProductivity(
                          a.productivity,
                          Theme.of(context).brightness,
                        ),
                      ),
                  ],
                ),
              ),
        ),
        const SizedBox(height: 16),
        const _UnclassifiedSection(),
      ],
    );
  }
}

/// Bloki, których reguły nie rozpoznały — czekają na jedną decyzję.
///
/// To jest pętla uczenia całej aplikacji: im więcej tu zaklasyfikujesz,
/// tym mniej niesklasyfikowanego czasu w statystykach. Bez tego ekranu
/// „bez klasyfikacji" rośnie w nieskończoność i wykresy przestają
/// cokolwiek znaczyć.
class _UnclassifiedSection extends ConsumerWidget {
  const _UnclassifiedSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(unclassifiedUsageProvider).value ?? const [];
    if (rows.isEmpty) return const SizedBox.shrink();

    return _Section(
      title: 'Do zaklasyfikowania',
      subtitle: 'Aplikacje, których reguły jeszcze nie znają.',
      child: Column(
        children: [
          for (final row in rows.take(8)) _ClassifyRow(usage: row),
        ],
      ),
    );
  }
}

class _ClassifyRow extends ConsumerWidget {
  const _ClassifyRow({required this.usage});

  final AppUsage usage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usage.appName.isEmpty ? usage.appId : usage.appName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  formatDuration(Duration(seconds: usage.durationSeconds)),
                  style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                ),
              ],
            ),
          ),
          for (final p in const [
            Productivity.productive,
            Productivity.neutral,
            Productivity.leisure,
            Productivity.distraction,
          ])
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Tooltip(
                message: productivityLabel(p),
                child: InkWell(
                  onTap: () => _classify(ref, p),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: VizColors.forProductivity(
                          p, Theme.of(context).brightness),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Klasyfikuje ten blok i od razu zakłada regułę na przyszłość.
  ///
  /// Bez tworzenia reguły ta sama aplikacja wracałaby tu codziennie
  /// i przegląd nigdy by się nie kończył.
  Future<void> _classify(WidgetRef ref, Productivity productivity) async {
    await ref.read(appUsageDaoProvider).reclassify(usage.id, productivity);
    await ref.read(ruleDaoProvider).createCustom(
          label: usage.appName.isEmpty ? usage.appId : usage.appName,
          pattern: usage.appId,
          productivity: productivity,
          matchType: MatchType.equals,
          platform: usage.platform,
        );
    await ref.read(trackingServiceProvider).reclassifyAll();
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
              ),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/util/dates.dart';
import '../common/undo.dart';
import '../insights/charts.dart';

/// Ekran „Dziś": stoper, wpisy z dzisiaj i podział czasu.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(todayEntriesProvider);
    final split = ref.watch(dayProductivityProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _TimerCard(),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Na co poszedł dzień',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Z automatycznego pomiaru aktywności, nie ze stopera.',
                  style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                ),
                const SizedBox(height: 16),
                split.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Nie udało się policzyć: $e'),
                  data: (data) => ProductivityStackedBar(split: data),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Wpisy czasu', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        entries.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Błąd: $e'),
          data: (rows) => rows.isEmpty
              ? const _EmptyHint(
                  'Nic dziś nie zmierzone. Uruchom stoper albo dopisz wpis ręcznie.')
              : Column(children: [for (final e in rows) _EntryTile(entry: e)]),
        ),
      ],
    );
  }
}

/// Karta stopera. Odlicza lokalnie co sekundę, ale źródłem prawdy
/// pozostaje wiersz w bazie — po restarcie aplikacji pomiar trwa dalej,
/// bo liczy się od zapisanego `startedAt`, a nie od momentu uruchomienia UI.
class _TimerCard extends ConsumerStatefulWidget {
  const _TimerCard();

  @override
  ConsumerState<_TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends ConsumerState<_TimerCard> {
  Timer? _ticker;
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = ref.watch(runningEntryProvider).value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: running == null ? _buildIdle() : _buildRunning(running),
      ),
    );
  }

  Widget _buildIdle() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Co robisz?',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (_) => _start(),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
        ),
      ],
    );
  }

  Widget _buildRunning(TimeEntry entry) {
    final elapsed = DateTime.now().toUtc().difference(entry.startedAt);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.description.isEmpty ? 'Bez opisu' : entry.description,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                formatDuration(elapsed),
                style: const TextStyle(fontSize: 32, height: 1.1),
              ),
              Text(
                'od ${TimeOfDay.fromDateTime(entry.startedAt.toLocal()).format(context)}',
                style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
              ),
            ],
          ),
        ),
        // Zapomniany stoper to najczęstszy powód śmieciowych danych.
        // Po przekroczeniu progu pytamy wprost, zamiast cicho zapisać
        // sześć godzin „pracy".
        if (elapsed > const Duration(hours: 4))
          IconButton(
            tooltip: 'Chodzi bardzo długo — popraw czas zakończenia',
            icon: const Icon(Icons.warning_amber),
            onPressed: () => _fixLongEntry(entry),
          ),
        FilledButton.icon(
          onPressed: _stop,
          icon: const Icon(Icons.stop),
          label: const Text('Stop'),
        ),
      ],
    );
  }

  Future<void> _start() async {
    final deviceId = await ref.read(deviceIdProvider.future);
    await ref.read(timeEntryDaoProvider).start(
          deviceId: deviceId,
          description: _descriptionController.text.trim(),
        );
    _descriptionController.clear();
  }

  Future<void> _stop() => ref.read(timeEntryDaoProvider).stop();

  Future<void> _fixLongEntry(TimeEntry entry) async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Stoper chodzi bardzo długo'),
        children: [
          for (final m in const [15, 30, 45, 60, 120])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, m),
              child: Text('Przytnij do ${formatDuration(Duration(minutes: m))}'),
            ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, -1),
            child: const Text('Zostaw jak jest'),
          ),
        ],
      ),
    );
    if (minutes == null || minutes < 0) return;

    await ref.read(timeEntryDaoProvider).stopAt(
          entry.id,
          entry.startedAt.add(Duration(minutes: minutes)),
        );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final TimeEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final end = entry.endedAt;
    final duration = end == null
        ? DateTime.now().toUtc().difference(entry.startedAt)
        : end.difference(entry.startedAt);

    final categories = ref.watch(categoryMapProvider);
    final category =
        entry.categoryId == null ? null : categories[entry.categoryId];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          entry.description.isEmpty ? 'Bez opisu' : entry.description,
        ),
        subtitle: Text(
          '${TimeOfDay.fromDateTime(entry.startedAt.toLocal()).format(context)}'
          '${end == null ? ' — trwa' : ' — ${TimeOfDay.fromDateTime(end.toLocal()).format(context)}'}'
          '${category == null ? '' : ' · ${category.name}'}',
        ),
        trailing: Text(
          formatDuration(duration),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onLongPress: () async {
          await ref.read(timeEntryDaoProvider).softDelete(entry.id);
          if (!context.mounted) return;
          showUndoSnackBar(
            context,
            message: 'Usunięto wpis czasu',
            onUndo: () => ref.read(timeEntryDaoProvider).restore(entry.id),
          );
        },
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: VizColors.inkMuted),
        ),
      ),
    );
  }
}

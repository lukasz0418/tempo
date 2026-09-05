import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/db/enums.dart';
import '../../core/estimation/estimation.dart';
import '../../core/util/dates.dart';
import '../common/undo.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(openTasksProvider);
    final stats = ref.watch(estimateStatsProvider).value;

    return Scaffold(
      body: Column(
        children: [
          if (stats != null) _EstimateBanner(stats: stats),
          Expanded(
            child: tasks.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Błąd: $e')),
              data: (rows) => rows.isEmpty
                  ? Center(
                      child: Text(
                        'Brak otwartych zadań.',
                        style: TextStyle(color: VizColors.inkMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: rows.length,
                      itemBuilder: (context, i) => _TaskTile(task: rows[i]),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Zadanie'),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (_) => const _AddTaskDialog(),
    );
  }
}

/// Pasek z informacją o twoim optymizmie w szacowaniu.
///
/// Pokazywany dopiero, gdy próbka jest wiarygodna — komunikat policzony
/// z trzech zadań byłby gorszy niż jego brak, bo brzmiałby tak samo
/// pewnie jak ten z dwustu.
class _EstimateBanner extends StatelessWidget {
  const _EstimateBanner({required this.stats});

  final EstimateStats stats;

  @override
  Widget build(BuildContext context) {
    if (!stats.isReliable) return const SizedBox.shrink();

    final text = stats.describe();
    if (text == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          const Icon(Icons.insights, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryMapProvider);
    final category = task.categoryId == null ? null : categories[task.categoryId];

    final estimate = formatEstimate(
      task.estimateMinSeconds == null
          ? null
          : Duration(seconds: task.estimateMinSeconds!),
      task.estimateMaxSeconds == null
          ? null
          : Duration(seconds: task.estimateMaxSeconds!),
    );

    final subtitle = <String>[
      if (estimate != '—') 'szac. $estimate',
      if (category != null) category.name,
      if (task.energy != null) _energyLabel(task.energy!),
      if (task.dueAt != null) 'termin ${dayKey(task.dueAt!)}',
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.done,
          onChanged: (_) => ref.read(taskDaoProvider).complete(task.id),
        ),
        title: Text(task.title),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Zadanie odkładane wielokrotnie dostaje widoczny znacznik.
            // To zaczepka, nie ozdoba: po siódmym przełożeniu zwykle
            // trzeba je skasować, a nie przełożyć ósmy raz.
            if (task.postponedCount >= 5)
              Tooltip(
                message: 'Przełożone ${task.postponedCount} razy',
                child: const Icon(Icons.snooze, size: 18),
              ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Zacznij mierzyć',
              onPressed: () async {
                final deviceId = await ref.read(deviceIdProvider.future);
                await ref.read(timeEntryDaoProvider).start(
                      deviceId: deviceId,
                      taskId: task.id,
                      categoryId: task.categoryId,
                      description: task.title,
                    );
              },
            ),
          ],
        ),
        onLongPress: () async {
          await ref.read(taskDaoProvider).softDelete(task.id);
          if (!context.mounted) return;
          showUndoSnackBar(
            context,
            message: 'Usunięto „${task.title}"',
            onUndo: () => ref.read(taskDaoProvider).restore(task.id),
          );
        },
      ),
    );
  }

  static String _energyLabel(EnergyKind e) => switch (e) {
        EnergyKind.focus => 'skupienie',
        EnergyKind.shallow => 'bezmyślne',
        EnergyKind.social => 'z ludźmi',
        EnergyKind.physical => 'fizyczne',
      };
}

class _AddTaskDialog extends ConsumerStatefulWidget {
  const _AddTaskDialog();

  @override
  ConsumerState<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<_AddTaskDialog> {
  final _title = TextEditingController();
  int _minMinutes = 15;
  int _maxMinutes = 30;
  String? _categoryId;
  EnergyKind? _energy;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final stats = ref.watch(estimateStatsProvider).value;

    final adjusted = stats != null && stats.isReliable
        ? Estimator.adjust(Duration(minutes: _maxMinutes), stats)
        : null;

    return AlertDialog(
      title: const Text('Nowe zadanie'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Co trzeba zrobić?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Ile to zajmie?',
                  style: TextStyle(fontSize: 13, color: VizColors.inkMuted)),
              const SizedBox(height: 8),
              // Estymata jako zakres, nie punkt — ludzie myślą
              // „jakieś 15–30 minut", a wymuszanie jednej liczby
              // produkuje precyzję, której nikt nie ma.
              Row(
                children: [
                  Expanded(
                    child: _MinutesField(
                      label: 'od',
                      value: _minMinutes,
                      onChanged: (v) => setState(() {
                        _minMinutes = v;
                        if (_maxMinutes < v) _maxMinutes = v;
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MinutesField(
                      label: 'do',
                      value: _maxMinutes,
                      onChanged: (v) => setState(() {
                        _maxMinutes = v;
                        if (_minMinutes > v) _minMinutes = v;
                      }),
                    ),
                  ),
                ],
              ),
              if (adjusted != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Historycznie zajmuje ci to więcej — realnie licz '
                  '${formatDuration(adjusted)}.',
                  style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                initialValue: _categoryId,
                decoration: const InputDecoration(
                  labelText: 'Kategoria',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('—')),
                  for (final c in categories)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => _categoryId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EnergyKind?>(
                initialValue: _energy,
                decoration: const InputDecoration(
                  labelText: 'Czego wymaga',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('—')),
                  for (final e in EnergyKind.values)
                    DropdownMenuItem(
                      value: e,
                      child: Text(_TaskTile._energyLabel(e)),
                    ),
                ],
                onChanged: (v) => setState(() => _energy = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(onPressed: _save, child: const Text('Dodaj')),
      ],
    );
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    await ref.read(taskDaoProvider).create(
          title: title,
          categoryId: _categoryId,
          estimateMin: Duration(minutes: _minMinutes),
          estimateMax: Duration(minutes: _maxMinutes),
          energy: _energy,
        );
    if (mounted) Navigator.pop(context);
  }
}

class _MinutesField extends StatelessWidget {
  const _MinutesField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  /// Gotowe kroki zamiast pola tekstowego. Wpisywanie „37" nie jest
  /// dokładniejsze od wybrania „30" — jest tylko wolniejsze.
  static const _steps = [5, 10, 15, 30, 45, 60, 90, 120, 180, 240];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: _steps.contains(value) ? value : _steps.first,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final m in _steps)
          DropdownMenuItem(
            value: m,
            child: Text(formatDuration(Duration(minutes: m))),
          ),
      ],
      onChanged: (v) => v == null ? null : onChanged(v),
    );
  }
}

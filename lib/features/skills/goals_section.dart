import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/daos/goal_dao.dart';
import '../../core/db/database.dart';
import '../../core/db/enums.dart';
import '../../core/util/dates.dart';
import '../common/undo.dart';

/// Cele przypięte do jednej umiejętności.
///
/// Rozdzielone na krótko- i długoterminowe, bo służą do czegoś innego:
/// długoterminowy nadaje kierunek, krótkoterminowy mówi, co zrobić w tym
/// tygodniu. Zmieszane na jednej liście przestają robić jedno i drugie.
class GoalsSection extends ConsumerWidget {
  const GoalsSection({required this.skillId, required this.color, super.key});

  final String skillId;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(skillGoalsProvider(skillId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Cele',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => AddGoalDialog(skillId: skillId),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Dodaj'),
                ),
              ],
            ),
            goals.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Błąd: $e'),
              data: (rows) {
                final active =
                    rows.where((g) => g.status == GoalStatus.active).toList();
                final done = rows
                    .where((g) => g.status == GoalStatus.achieved)
                    .toList();

                if (rows.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Brak celów. Większość liczy się sama z mierzonego '
                      'czasu — nie trzeba niczego odhaczać.',
                      style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final horizon in GoalHorizon.values)
                      ..._buildHorizon(context, horizon, active),
                    if (done.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Osiągnięte (${done.length})',
                        style: TextStyle(
                          fontSize: 12,
                          color: VizColors.inkMuted,
                        ),
                      ),
                      for (final g in done) _AchievedRow(goal: g),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHorizon(
      BuildContext context, GoalHorizon horizon, List<Goal> active) {
    final matching = active.where((g) => g.horizon == horizon).toList();
    if (matching.isEmpty) return const [];

    return [
      const SizedBox(height: 12),
      Text(
        horizon == GoalHorizon.short ? 'Krótkoterminowe' : 'Długoterminowe',
        style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
      ),
      const SizedBox(height: 8),
      for (final g in matching) _GoalRow(goal: g, color: color),
    ];
  }
}

class _GoalRow extends ConsumerWidget {
  const _GoalRow({required this.goal, required this.color});

  final Goal goal;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(goalProgressProvider(goal.id)).value;
    final manual = goal.metric == GoalMetric.milestone ||
        goal.metric == GoalMetric.custom;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(goal.title)),
              if (manual) _ManualControls(goal: goal),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, size: 16),
                tooltip: 'Usuń cel',
                onPressed: () async {
                  await ref.read(goalDaoProvider).softDelete(goal.id);
                  if (!context.mounted) return;
                  showUndoSnackBar(
                    context,
                    message: 'Usunięto cel',
                    onUndo: () => ref.read(goalDaoProvider).restore(goal.id),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (progress == null)
            const LinearProgressIndicator(minHeight: 6)
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.fraction,
                minHeight: 6,
                backgroundColor: VizColors.grid(Theme.of(context).brightness),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  progress.describe(),
                  style: TextStyle(fontSize: 11, color: VizColors.inkMuted),
                ),
                const Spacer(),
                if (progress.deadline != null)
                  Text(
                    _deadlineLabel(progress),
                    style: TextStyle(
                      fontSize: 11,
                      // Termin po czasie to jedyne miejsce, gdzie kolor
                      // niesie znaczenie — i towarzyszy mu słowo,
                      // więc nie zależy od samego odcienia.
                      color: progress.isOverdue
                          ? const Color(0xFFD03B3B)
                          : VizColors.inkMuted,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _deadlineLabel(GoalProgress p) {
    final days = p.daysLeft;
    if (days == null) return '';
    if (days < 0) return 'po terminie o ${-days} dni';
    if (days == 0) return 'termin dzisiaj';
    if (days == 1) return 'zostal 1 dzień';
    return 'zostało $days dni';
  }
}

/// Sterowanie ręcznym licznikiem — dla celów, których nie da się wyliczyć.
class _ManualControls extends ConsumerWidget {
  const _ManualControls({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (goal.metric == GoalMetric.milestone) {
      return Checkbox(
        value: goal.manualProgress >= 1,
        onChanged: (v) => ref
            .read(goalDaoProvider)
            .bumpManual(goal.id, (v ?? false) ? 1 : -1),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.remove, size: 16),
          onPressed: () => ref.read(goalDaoProvider).bumpManual(goal.id, -1),
        ),
        Text('${goal.manualProgress}'),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add, size: 16),
          onPressed: () => ref.read(goalDaoProvider).bumpManual(goal.id, 1),
        ),
      ],
    );
  }
}

class _AchievedRow extends StatelessWidget {
  const _AchievedRow({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: Color(0xFF0CA30C)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              goal.title,
              style: TextStyle(
                fontSize: 13,
                color: VizColors.inkSecondary(Theme.of(context).brightness),
              ),
            ),
          ),
          if (goal.achievedAt != null)
            Text(
              dayKey(goal.achievedAt!),
              style: TextStyle(fontSize: 11, color: VizColors.inkMuted),
            ),
        ],
      ),
    );
  }
}

class AddGoalDialog extends ConsumerStatefulWidget {
  const AddGoalDialog({required this.skillId, super.key});

  final String skillId;

  @override
  ConsumerState<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends ConsumerState<AddGoalDialog> {
  final _title = TextEditingController();
  GoalHorizon _horizon = GoalHorizon.short;
  GoalMetric _metric = GoalMetric.minutes;
  int _target = 600;
  DateTime? _deadline;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  /// Sensowne wartości docelowe dla każdej metryki — żeby nie trzeba było
  /// przeliczać godzin na minuty w głowie przy dodawaniu celu.
  static const _targets = {
    GoalMetric.minutes: [
      (300, '5 godzin'),
      (600, '10 godzin'),
      (1800, '30 godzin'),
      (3000, '50 godzin'),
      (6000, '100 godzin'),
    ],
    GoalMetric.sessions: [
      (10, '10 sesji'),
      (25, '25 sesji'),
      (50, '50 sesji'),
      (100, '100 sesji'),
    ],
    GoalMetric.streakDays: [
      (7, '7 dni z rzędu'),
      (14, '14 dni z rzędu'),
      (30, '30 dni z rzędu'),
      (100, '100 dni z rzędu'),
    ],
    GoalMetric.practiceDays: [
      (12, '12 dni ćwiczeń'),
      (20, '20 dni ćwiczeń'),
      (50, '50 dni ćwiczeń'),
    ],
    GoalMetric.custom: [
      (5, '5 sztuk'),
      (12, '12 sztuk'),
      (30, '30 sztuk'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final options = _targets[_metric] ?? const <(int, String)>[];

    return AlertDialog(
      title: const Text('Nowy cel'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Co chcesz osiągnąć?',
                  hintText: 'Zagrać cały utwór bez pomyłki',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<GoalHorizon>(
                segments: const [
                  ButtonSegment(
                    value: GoalHorizon.short,
                    label: Text('Krótkoterminowy'),
                  ),
                  ButtonSegment(
                    value: GoalHorizon.long,
                    label: Text('Długoterminowy'),
                  ),
                ],
                selected: {_horizon},
                onSelectionChanged: (s) => setState(() => _horizon = s.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GoalMetric>(
                initialValue: _metric,
                decoration: const InputDecoration(
                  labelText: 'Jak mierzyć',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: GoalMetric.minutes,
                    child: Text('Przećwiczony czas — liczy się sam'),
                  ),
                  DropdownMenuItem(
                    value: GoalMetric.sessions,
                    child: Text('Liczba sesji — liczy się sama'),
                  ),
                  DropdownMenuItem(
                    value: GoalMetric.streakDays,
                    child: Text('Dni z rzędu — liczy się samo'),
                  ),
                  DropdownMenuItem(
                    value: GoalMetric.practiceDays,
                    child: Text('Dni ćwiczeń — liczy się samo'),
                  ),
                  DropdownMenuItem(
                    value: GoalMetric.milestone,
                    child: Text('Osiągnięcie — odhaczasz ręcznie'),
                  ),
                  DropdownMenuItem(
                    value: GoalMetric.custom,
                    child: Text('Własny licznik'),
                  ),
                ],
                onChanged: (v) => setState(() {
                  _metric = v ?? GoalMetric.minutes;
                  final first = _targets[_metric]?.first.$1;
                  if (first != null) _target = first;
                }),
              ),
              if (options.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue:
                      options.any((o) => o.$1 == _target) ? _target : options.first.$1,
                  decoration: const InputDecoration(
                    labelText: 'Ile',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final o in options)
                      DropdownMenuItem(value: o.$1, child: Text(o.$2)),
                  ],
                  onChanged: (v) => setState(() => _target = v ?? _target),
                ),
              ],
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_deadline == null
                    ? 'Bez terminu'
                    : 'Termin: ${dayKey(_deadline!)}'),
                subtitle: Text(
                  'Cele długoterminowe często nie potrzebują daty.',
                  style: TextStyle(fontSize: 11, color: VizColors.inkMuted),
                ),
                trailing: TextButton(
                  onPressed: _pickDeadline,
                  child: Text(_deadline == null ? 'Ustaw' : 'Zmień'),
                ),
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

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    await ref.read(goalDaoProvider).create(
          title: title,
          skillId: widget.skillId,
          horizon: _horizon,
          metric: _metric,
          targetValue: _target,
          deadline: _deadline,
        );
    if (mounted) Navigator.pop(context);
  }
}

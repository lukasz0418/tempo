import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/daos/skill_dao.dart';
import '../../core/db/database.dart';
import '../../core/util/dates.dart';
import '../common/undo.dart';
import 'skill_detail_screen.dart';

/// Lista śledzonych umiejętności.
class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);

    return Scaffold(
      body: skills.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Błąd: $e')),
        data: (rows) {
          if (rows.isEmpty) return const _EmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            itemBuilder: (context, i) => _SkillCard(skill: rows[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const AddSkillDialog(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Umiejętność'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_up, size: 48, color: VizColors.inkMuted),
            const SizedBox(height: 16),
            Text(
              'Dodaj coś, w czym chcesz się rozwijać.\n'
              'Każda sesja ćwiczeń to wpis w dzienniku — z nagraniem, '
              'zdjęciem i notatką.',
              textAlign: TextAlign.center,
              style: TextStyle(color: VizColors.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends ConsumerWidget {
  const _SkillCard({required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(skillProgressProvider(skill.id)).value;
    final color = Color(skill.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SkillDetailScreen(skillId: skill.id),
          ),
        ),
        onLongPress: () async {
          await ref.read(skillDaoProvider).softDelete(skill.id);
          if (!context.mounted) return;
          showUndoSnackBar(
            context,
            message: 'Usunięto „${skill.name}"',
            onUndo: () => ref.read(skillDaoProvider).restore(skill.id),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      skill.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (progress != null && progress.currentStreak > 0)
                    _StreakChip(days: progress.currentStreak),
                ],
              ),
              if (skill.intent != null && skill.intent!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  skill.intent!,
                  style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                ),
              ],
              const SizedBox(height: 16),
              if (progress == null)
                const LinearProgressIndicator()
              else
                _ProgressRow(progress: progress, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, size: 14),
          const SizedBox(width: 4),
          Text('$days', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/// Trzy liczby obok siebie — celowo, bo każda z osobna kłamie.
///
/// Same godziny nie mówią nic o postępie (można ćwiczyć bezmyślnie),
/// sama regularność nie mówi o głębokości pracy, a sama samoocena
/// bywa nastrojem. Dopiero razem układają się w obraz.
class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.progress, required this.color});

  final SkillProgress progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final average = progress.averageRating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Stat(label: 'Łącznie', value: formatDurationOrDash(progress.total)),
            _Stat(
              label: '30 dni',
              value: formatDurationOrDash(progress.last30Days),
            ),
            _Stat(
              label: 'Dni ćwiczone',
              value: '${progress.daysPracticedLast30}/30',
            ),
            _Stat(
              label: 'Samoocena',
              value: average == null ? '—' : average.toStringAsFixed(1),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Pasek regularności — jedyna wartość, którą warto tu pokazać
        // graficznie, bo ma naturalny sufit (30 dni z 30).
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.consistency.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: VizColors.grid(Theme.of(context).brightness),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: VizColors.inkMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: VizColors.ink(brightness),
            ),
          ),
        ],
      ),
    );
  }
}

class AddSkillDialog extends ConsumerStatefulWidget {
  const AddSkillDialog({super.key});

  @override
  ConsumerState<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends ConsumerState<AddSkillDialog> {
  final _name = TextEditingController();
  final _intent = TextEditingController();
  int _colorIndex = 0;
  int? _weeklyTarget;

  /// Podpowiedzi na skróty. Wpisać można cokolwiek — to tylko oszczędność
  /// stukania w klawiaturę na telefonie, nie zamknięta lista.
  static const _suggestions = [
    'Śpiew',
    'Gitara',
    'Pianino',
    'Kalistenika',
    'Cardio',
  ];

  static const _palette = [
    Color(0xFF2A78D6),
    Color(0xFF1BAF7A),
    Color(0xFFEB6834),
    Color(0xFF7950F2),
    Color(0xFFE87BA4),
    Color(0xFFEDA100),
  ];

  @override
  void dispose() {
    _name.dispose();
    _intent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa umiejętność'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Co śledzisz?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final s in _suggestions)
                    ActionChip(
                      label: Text(s),
                      onPressed: () => setState(() => _name.text = s),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _intent,
                decoration: const InputDecoration(
                  labelText: 'Po co? (opcjonalnie)',
                  hintText: 'Żeby zaśpiewać czysto cały utwór',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Kolor',
                  style: TextStyle(fontSize: 13, color: VizColors.inkMuted)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (var i = 0; i < _palette.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() => _colorIndex = i),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _palette[i],
                            shape: BoxShape.circle,
                            border: _colorIndex == i
                                ? Border.all(width: 3, color: Colors.black26)
                                : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                initialValue: _weeklyTarget,
                decoration: const InputDecoration(
                  labelText: 'Cel tygodniowy',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('bez celu')),
                  DropdownMenuItem(value: 60, child: Text('1 h / tydzień')),
                  DropdownMenuItem(value: 120, child: Text('2 h / tydzień')),
                  DropdownMenuItem(value: 210, child: Text('3,5 h / tydzień')),
                  DropdownMenuItem(value: 420, child: Text('7 h / tydzień')),
                ],
                onChanged: (v) => setState(() => _weeklyTarget = v),
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
    final name = _name.text.trim();
    if (name.isEmpty) return;

    await ref.read(skillDaoProvider).create(
          name: name,
          color: _palette[_colorIndex].toARGB32(),
          intent: _intent.text.trim().isEmpty ? null : _intent.text.trim(),
          weeklyTargetMinutes: _weeklyTarget,
        );
    if (mounted) Navigator.pop(context);
  }
}

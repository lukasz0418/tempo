import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/util/dates.dart';
import '../common/undo.dart';
import '../insights/charts.dart';
import 'goals_section.dart';
import 'journal_entry_screen.dart';

/// Jedna umiejętność: postęp, oś kamieni milowych, dziennik sesji.
class SkillDetailScreen extends ConsumerWidget {
  const SkillDetailScreen({required this.skillId, super.key});

  final String skillId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider).value ?? const <Skill>[];
    final skill = skills.where((s) => s.id == skillId).firstOrNull;
    final entries = ref.watch(journalEntriesProvider(skillId));

    if (skill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Umiejętność')),
        body: const Center(child: Text('Nie znaleziono.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(skill.name),
        actions: [
          IconButton(
            tooltip: 'Zacznij ćwiczyć',
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _startSession(context, ref, skill),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProgressCard(skillId: skillId, color: Color(skill.color)),
          const SizedBox(height: 16),
          GoalsSection(skillId: skillId, color: Color(skill.color)),
          const SizedBox(height: 16),
          Text('Dziennik', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          entries.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Błąd: $e'),
            data: (rows) => rows.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Brak wpisów. Po sesji dopisz, co ćwiczyłeś '
                      'i jak poszło — z nagraniem, jeśli chcesz usłyszeć '
                      'różnicę za pół roku.',
                      style: TextStyle(color: VizColors.inkMuted),
                    ),
                  )
                : Column(
                    children: [
                      for (final e in rows)
                        _EntryTile(entry: e, skillColor: Color(skill.color)),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final id = await ref.read(journalDaoProvider).create(skillId: skillId);
          if (!context.mounted) return;
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => JournalEntryScreen(entryId: id),
            ),
          );
        },
        icon: const Icon(Icons.edit_note),
        label: const Text('Wpis'),
      ),
    );
  }

  Future<void> _startSession(
      BuildContext context, WidgetRef ref, Skill skill) async {
    final deviceId = await ref.read(deviceIdProvider.future);
    await ref.read(timeEntryDaoProvider).start(
          deviceId: deviceId,
          skillId: skill.id,
          description: skill.name,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mierzę czas: ${skill.name}')),
    );
  }
}

class _ProgressCard extends ConsumerWidget {
  const _ProgressCard({required this.skillId, required this.color});

  final String skillId;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(skillProgressProvider(skillId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: progress.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Błąd: $e'),
          data: (p) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Metric(
                      label: 'Łącznie', value: formatDuration(p.total)),
                  _Metric(
                      label: 'Sesje', value: '${p.sessionCount}'),
                  _Metric(
                      label: 'Seria', value: '${p.currentStreak} dni'),
                  _Metric(
                    label: 'Kamienie',
                    value: '${p.milestoneCount}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Regularność — ${p.daysPracticedLast30} z ostatnich 30 dni',
                style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: p.consistency.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor:
                      VizColors.grid(Theme.of(context).brightness),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Jak oceniasz swoje sesje',
                style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
              ),
              const SizedBox(height: 8),
              RatingTrend(
                values: p.ratingTrend.map((r) => r.rating).toList(),
                color: color,
              ),
              if (p.lastPracticedAt != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Ostatnio: ${dayKey(p.lastPracticedAt!)}',
                  style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: VizColors.inkMuted)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: VizColors.ink(Theme.of(context).brightness),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry, required this.skillColor});

  final JournalEntry entry;
  final Color skillColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachments =
        ref.watch(attachmentsProvider(entry.id)).value ?? const <Attachment>[];

    final title = entry.title.trim().isEmpty
        ? (entry.body.trim().isEmpty
            ? 'Wpis bez tytułu'
            : entry.body.trim().split('\n').first)
        : entry.title;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: entry.isMilestone
            ? Icon(Icons.flag, color: skillColor)
            : const Icon(Icons.notes),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Row(
          children: [
            Text(entry.date),
            if (entry.selfRating != null) ...[
              const SizedBox(width: 8),
              Text('· ocena ${entry.selfRating}/5'),
            ],
            if (attachments.isNotEmpty) ...[
              const SizedBox(width: 8),
              const Icon(Icons.attach_file, size: 14),
              Text('${attachments.length}'),
            ],
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => JournalEntryScreen(entryId: entry.id),
          ),
        ),
        onLongPress: () async {
          await ref.read(journalDaoProvider).softDelete(entry.id);
          if (!context.mounted) return;
          showUndoSnackBar(
            context,
            message: 'Usunięto wpis',
            onUndo: () => ref.read(journalDaoProvider).restore(entry.id),
          );
        },
      ),
    );
  }
}

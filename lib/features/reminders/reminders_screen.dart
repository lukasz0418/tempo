import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/daos/reminder_dao.dart';
import '../../core/db/database.dart';
import '../common/undo.dart';

/// Przypomnienia o ćwiczeniach.
///
/// Każda zmiana kończy się przeplanowaniem wszystkich alarmów od nowa.
/// Wygląda to na rozrzutność, ale jest jedynym podejściem, które nie
/// rozjeżdża się z bazą: Android i tak kasuje zaplanowane powiadomienia
/// przy restarcie telefonu, więc pełne odtworzenie musi działać niezawodnie.
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Przypomnienia')),
      body: !Platform.isAndroid
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Przypomnienia działają na telefonie. Na komputerze '
                  'możesz je tu skonfigurować — pojawią się na Androidzie '
                  'po synchronizacji.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: VizColors.inkMuted),
                ),
              ),
            )
          : reminders.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Błąd: $e')),
              data: (rows) => rows.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Brak przypomnień.\n'
                          'Jedno o stałej porze działa lepiej niż pięć '
                          'rozrzuconych po dniu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: VizColors.inkMuted),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        for (final r in rows) _ReminderTile(reminder: r),
                      ],
                    ),
            ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton.extended(
              onPressed: () => _add(context, ref),
              icon: const Icon(Icons.add_alarm),
              label: const Text('Przypomnienie'),
            )
          : null,
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    // Zgoda na powiadomienia (Android 13+) przed dodaniem czegokolwiek —
    // przypomnienie zapisane bez zgody wyglądałoby na działające,
    // a nigdy by się nie pokazało.
    final granted =
        await ref.read(notificationServiceProvider).requestPermission();

    if (!context.mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bez zgody na powiadomienia przypomnienia się nie pojawią.',
          ),
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => const AddReminderDialog(),
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = parseWeekdays(reminder.weekdays);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        value: reminder.enabled,
        title: Text(reminder.title),
        subtitle: Text(
          '${formatMinuteOfDay(reminder.minuteOfDay)} · ${describeWeekdays(days)}'
          '${reminder.body == null || reminder.body!.isEmpty ? '' : '\n${reminder.body}'}',
        ),
        isThreeLine: reminder.body != null && reminder.body!.isNotEmpty,
        secondary: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            await ref.read(reminderDaoProvider).softDelete(reminder.id);
            await ref.read(notificationServiceProvider).rescheduleAll();
            if (!context.mounted) return;
            showUndoSnackBar(
              context,
              message: 'Usunięto przypomnienie',
              onUndo: () async {
                await ref.read(reminderDaoProvider).restore(reminder.id);
                await ref.read(notificationServiceProvider).rescheduleAll();
              },
            );
          },
        ),
        onChanged: (value) async {
          await ref
              .read(reminderDaoProvider)
              .setEnabled(reminder.id, enabled: value);
          await ref.read(notificationServiceProvider).rescheduleAll();
        },
      ),
    );
  }
}

class AddReminderDialog extends ConsumerStatefulWidget {
  const AddReminderDialog({super.key});

  @override
  ConsumerState<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends ConsumerState<AddReminderDialog> {
  final _title = TextEditingController(text: 'Czas poćwiczyć');
  final _body = TextEditingController();
  TimeOfDay _time = const TimeOfDay(hour: 19, minute: 0);
  final Set<int> _days = {};
  String? _skillId;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  static const _dayLabels = {
    DateTime.monday: 'Pn',
    DateTime.tuesday: 'Wt',
    DateTime.wednesday: 'Śr',
    DateTime.thursday: 'Cz',
    DateTime.friday: 'Pt',
    DateTime.saturday: 'So',
    DateTime.sunday: 'Nd',
  };

  @override
  Widget build(BuildContext context) {
    final skills = ref.watch(skillsProvider).value ?? const <Skill>[];

    return AlertDialog(
      title: const Text('Nowe przypomnienie'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Treść',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _body,
                decoration: const InputDecoration(
                  labelText: 'Szczegóły (opcjonalnie)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text('Godzina: ${_time.format(context)}'),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _time,
                    );
                    if (picked != null) setState(() => _time = picked);
                  },
                  child: const Text('Zmień'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _days.isEmpty ? 'Codziennie' : 'Wybrane dni',
                style: TextStyle(fontSize: 13, color: VizColors.inkMuted),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  for (final entry in _dayLabels.entries)
                    FilterChip(
                      label: Text(entry.value),
                      selected: _days.contains(entry.key),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _days.add(entry.key);
                        } else {
                          _days.remove(entry.key);
                        }
                      }),
                    ),
                ],
              ),
              if (skills.isNotEmpty) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  initialValue: _skillId,
                  decoration: const InputDecoration(
                    labelText: 'Dotyczy umiejętności',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('—')),
                    for (final s in skills)
                      DropdownMenuItem(value: s.id, child: Text(s.name)),
                  ],
                  onChanged: (v) => setState(() => _skillId = v),
                ),
              ],
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

    await ref.read(reminderDaoProvider).create(
          title: title,
          minuteOfDay: _time.hour * 60 + _time.minute,
          body: _body.text.trim().isEmpty ? null : _body.text.trim(),
          weekdays: _days.toList()..sort(),
          skillId: _skillId,
        );
    await ref.read(notificationServiceProvider).rescheduleAll();
    if (mounted) Navigator.pop(context);
  }
}

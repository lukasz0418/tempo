import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/db/enums.dart';
import '../../core/ideas/idea_export.dart';
import '../common/undo.dart';

/// Tablica pomysłów: co dodać, co zmienić, co jest zepsute.
///
/// Sens tego ekranu jest w przycisku eksportu. Pomysły przychodzą w trakcie
/// używania aplikacji, a nie przy komputerze z otwartym edytorem — tu je
/// zapisujesz, a potem jednym kliknięciem masz gotowy Markdown do wklejenia
/// w rozmowę z asystentem.
class IdeasScreen extends ConsumerWidget {
  const IdeasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ideas = ref.watch(allIdeasProvider);

    return Scaffold(
      body: ideas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Błąd: $e')),
        data: (rows) {
          if (rows.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Pusto. Zapisuj tu wszystko, co przyjdzie ci do głowy '
                  'w trakcie używania — potem wyeksportujesz to jednym '
                  'kliknięciem.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: VizColors.inkMuted),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ExportBar(ideas: rows),
              const SizedBox(height: 16),
              for (final idea in rows) _IdeaTile(idea: idea),
              const SizedBox(height: 8),
              const _TrashLink(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const _AddIdeaDialog(),
        ),
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Pomysł'),
      ),
    );
  }
}

class _ExportBar extends ConsumerWidget {
  const _ExportBar({required this.ideas});

  final List<Idea> ideas;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ideas
        .where((i) =>
            i.status != IdeaStatus.done && i.status != IdeaStatus.rejected)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Eksport do rozmowy',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '$open otwartych pomysłów. Markdown z opisem projektu '
                    'w nagłówku, gotowy do wklejenia.',
                    style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => _export(context, ref),
              icon: const Icon(Icons.copy_all),
              label: const Text('Kopiuj'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final markdown = IdeaExporter.export(ideas);
    await Clipboard.setData(ClipboardData(text: markdown));

    final exportedIds = ideas
        .where((i) =>
            i.status != IdeaStatus.done && i.status != IdeaStatus.rejected)
        .map((i) => i.id)
        .toList();
    await ref.read(ideaDaoProvider).markExported(exportedIds);

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skopiowane do schowka'),
        content: SizedBox(
          width: 560,
          height: 400,
          child: SingleChildScrollView(
            // Podgląd, a nie tylko komunikat — żeby dało się sprawdzić,
            // co właściwie wyląduje w rozmowie, zanim to wkleisz.
            child: SelectableText(
              markdown,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }
}

class _IdeaTile extends ConsumerWidget {
  const _IdeaTile({required this.idea});

  final Idea idea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(_kindIcon(idea.kind), size: 20),
        title: Text(idea.title),
        subtitle: idea.body == null || idea.body!.isEmpty
            ? Text(_statusLabel(idea.status))
            : Text('${_statusLabel(idea.status)} · ${idea.body}',
                maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton<IdeaStatus>(
          onSelected: (s) => ref.read(ideaDaoProvider).setStatus(idea.id, s),
          itemBuilder: (context) => [
            for (final s in IdeaStatus.values)
              PopupMenuItem(value: s, child: Text(_statusLabel(s))),
          ],
        ),
        onLongPress: () async {
          await ref.read(ideaDaoProvider).softDelete(idea.id);
          if (!context.mounted) return;
          showUndoSnackBar(
            context,
            message: 'Usunięto „${idea.title}"',
            onUndo: () => ref.read(ideaDaoProvider).restore(idea.id),
          );
        },
      ),
    );
  }

  static IconData _kindIcon(IdeaKind k) => switch (k) {
        IdeaKind.feature => Icons.add_circle_outline,
        IdeaKind.change => Icons.edit_outlined,
        IdeaKind.bug => Icons.bug_report_outlined,
        IdeaKind.question => Icons.help_outline,
      };

  static String _statusLabel(IdeaStatus s) => switch (s) {
        IdeaStatus.inbox => 'nowe',
        IdeaStatus.considering => 'do przemyślenia',
        IdeaStatus.planned => 'zaplanowane',
        IdeaStatus.done => 'zrobione',
        IdeaStatus.rejected => 'odrzucone',
      };
}

/// Wejście do kosza. Pokazuje się tylko wtedy, gdy jest co przywracać —
/// pusty kosz to pozycja, która zajmuje miejsce i niczego nie wnosi.
class _TrashLink extends ConsumerWidget {
  const _TrashLink();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleted = ref.watch(deletedIdeasProvider).value ?? const <Idea>[];
    if (deleted.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const _TrashScreen()),
        ),
        icon: const Icon(Icons.delete_outline, size: 18),
        label: Text('Kosz (${deleted.length})'),
      ),
    );
  }
}

class _TrashScreen extends ConsumerWidget {
  const _TrashScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleted = ref.watch(deletedIdeasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kosz')),
      body: deleted.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Błąd: $e')),
        data: (rows) {
          if (rows.isEmpty) {
            return Center(
              child: Text(
                'Pusto.',
                style: TextStyle(color: VizColors.inkMuted),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Skasowane pomysły nie znikają z bazy — trzymamy je jako '
                'znaczniki usunięcia na potrzeby synchronizacji. Dlatego '
                'da się je odzyskać.',
                style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
              ),
              const SizedBox(height: 16),
              for (final idea in rows)
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(idea.title),
                    subtitle: idea.body == null || idea.body!.isEmpty
                        ? null
                        : Text(idea.body!,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: TextButton(
                      onPressed: () =>
                          ref.read(ideaDaoProvider).restore(idea.id),
                      child: const Text('Przywróć'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AddIdeaDialog extends ConsumerStatefulWidget {
  const _AddIdeaDialog();

  @override
  ConsumerState<_AddIdeaDialog> createState() => _AddIdeaDialogState();
}

class _AddIdeaDialogState extends ConsumerState<_AddIdeaDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  IdeaKind _kind = IdeaKind.feature;
  int _impact = 3;
  int _effort = 3;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowy pomysł'),
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
                  labelText: 'W jednym zdaniu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _body,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Szczegóły (opcjonalnie)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<IdeaKind>(
                segments: const [
                  ButtonSegment(value: IdeaKind.feature, label: Text('Funkcja')),
                  ButtonSegment(value: IdeaKind.change, label: Text('Zmiana')),
                  ButtonSegment(value: IdeaKind.bug, label: Text('Błąd')),
                  ButtonSegment(value: IdeaKind.question, label: Text('Pytanie')),
                ],
                selected: {_kind},
                onSelectionChanged: (s) => setState(() => _kind = s.first),
              ),
              const SizedBox(height: 16),
              _Slider(
                label: 'Wpływ',
                value: _impact,
                onChanged: (v) => setState(() => _impact = v),
              ),
              _Slider(
                label: 'Koszt',
                value: _effort,
                onChanged: (v) => setState(() => _effort = v),
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
        FilledButton(onPressed: _save, child: const Text('Zapisz')),
      ],
    );
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    await ref.read(ideaDaoProvider).add(
          title: title,
          body: _body.text.trim().isEmpty ? null : _body.text.trim(),
          kind: _kind,
          impact: _impact,
          effort: _effort,
        );
    if (mounted) Navigator.pop(context);
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label)),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$value',
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
      ],
    );
  }
}

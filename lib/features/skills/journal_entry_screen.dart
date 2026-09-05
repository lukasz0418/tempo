import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/db/enums.dart';
import '../../core/media/media_capture.dart';
import '../common/undo.dart';
import 'attachment_tile.dart';

/// Jedna strona dziennika: tytuł, treść w Markdownie, ocena, załączniki.
///
/// Zapis jest **automatyczny**, z opóźnieniem sekundy od ostatniego
/// naciśnięcia klawisza. Notatka pisana po ćwiczeniu bywa przerwana
/// telefonem albo zamknięciem aplikacji — przycisk „Zapisz", o którym
/// można zapomnieć, jest tu najprostszym sposobem na utratę tekstu.
class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({required this.entryId, super.key});

  final String entryId;

  @override
  ConsumerState<JournalEntryScreen> createState() =>
      _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  Timer? _saveDebounce;
  bool _loaded = false;
  bool _preview = false;
  int? _rating;
  bool _isMilestone = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _title.addListener(_scheduleSave);
    _body.addListener(_scheduleSave);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    // Zapis synchroniczny przy wyjściu — debounce mógł jeszcze nie zdążyć,
    // a wtedy ostatnie zdanie przepadłoby bez śladu.
    _saveNow();
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 1), _saveNow);
  }

  void _saveNow() {
    if (!_loaded) return;
    ref.read(journalDaoProvider).save(JournalEntriesCompanion(
          id: Value(widget.entryId),
          title: Value(_title.text.trim()),
          body: Value(_body.text),
          selfRating: Value(_rating),
          isMilestone: Value(_isMilestone),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(journalPageProvider(widget.entryId));

    return page.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Błąd: $e'))),
      data: (data) {
        if (data == null) {
          return const Scaffold(body: Center(child: Text('Wpis nie istnieje.')));
        }

        if (!_loaded) {
          _loaded = true;
          _title.text = data.entry.title;
          _body.text = data.entry.body;
          _rating = data.entry.selfRating;
          _isMilestone = data.entry.isMilestone;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(data.entry.date),
            actions: [
              IconButton(
                tooltip: _preview ? 'Edytuj' : 'Podgląd',
                icon: Icon(_preview ? Icons.edit : Icons.visibility),
                onPressed: () => setState(() => _preview = !_preview),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _title,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: const InputDecoration(
                  hintText: 'Tytuł',
                  border: InputBorder.none,
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              _preview ? _buildPreview() : _buildEditor(),
              const SizedBox(height: 24),
              _buildRating(),
              const SizedBox(height: 16),
              _buildMilestoneToggle(),
              const SizedBox(height: 24),
              _AttachmentsSection(
                entryId: widget.entryId,
                attachments: data.attachments,
              ),
              const SizedBox(height: 16),
              if (_busy) const LinearProgressIndicator(),
              _buildCaptureBar(),
              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditor() {
    return TextField(
      controller: _body,
      maxLines: null,
      minLines: 8,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: 'Co ćwiczyłeś? Co poszło, co nie?\n\n'
            'Możesz używać Markdownu: **pogrubienie**, - lista, # nagłówek',
        hintStyle: TextStyle(color: VizColors.inkMuted),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildPreview() {
    final text = _body.text.trim();
    if (text.isEmpty) {
      return Text(
        'Pusty wpis.',
        style: TextStyle(color: VizColors.inkMuted),
      );
    }
    return MarkdownBody(data: text, selectable: true);
  }

  Widget _buildRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jak poszło?',
            style: TextStyle(fontSize: 13, color: VizColors.inkMuted)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('$i'),
                  selected: _rating == i,
                  onSelected: (selected) {
                    setState(() => _rating = selected ? i : null);
                    _saveNow();
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestoneToggle() {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: _isMilestone,
      title: const Text('Kamień milowy'),
      subtitle: Text(
        'Przełom, do którego będziesz wracać.',
        style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
      ),
      onChanged: (v) {
        setState(() => _isMilestone = v);
        _saveNow();
      },
    );
  }

  Widget _buildCaptureBar() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _RecordButton(entryId: widget.entryId, onBusy: _setBusy),
        OutlinedButton.icon(
          onPressed: () => _capture((c) => c.takePhoto()),
          icon: const Icon(Icons.photo_camera, size: 18),
          label: const Text('Zdjęcie'),
        ),
        OutlinedButton.icon(
          onPressed: () => _captureMany((c) => c.pickPhotos()),
          icon: const Icon(Icons.photo_library, size: 18),
          label: const Text('Z galerii'),
        ),
        OutlinedButton.icon(
          onPressed: () => _capture((c) => c.recordVideo()),
          icon: const Icon(Icons.videocam, size: 18),
          label: const Text('Wideo'),
        ),
      ],
    );
  }

  void _setBusy(bool value) {
    if (mounted) setState(() => _busy = value);
  }

  Future<void> _capture(
      Future<CapturedMedia?> Function(MediaCapture) action) async {
    _setBusy(true);
    try {
      final capture = await ref.read(mediaCaptureProvider.future);
      final media = await action(capture);
      if (media == null) return;
      await _persist([media]);
    } finally {
      _setBusy(false);
    }
  }

  Future<void> _captureMany(
      Future<List<CapturedMedia>> Function(MediaCapture) action) async {
    _setBusy(true);
    try {
      final capture = await ref.read(mediaCaptureProvider.future);
      await _persist(await action(capture));
    } finally {
      _setBusy(false);
    }
  }

  Future<void> _persist(List<CapturedMedia> items) async {
    final dao = ref.read(journalDaoProvider);
    for (final m in items) {
      await dao.addAttachment(
        entryId: widget.entryId,
        kind: m.kind,
        fileName: m.stored.fileName,
        sha256: m.stored.sha256,
        label: m.label,
        mimeType: m.stored.mimeType,
        bytes: m.stored.bytes,
        durationMs: m.durationMs,
      );
    }
  }
}

/// Przycisk nagrywania z licznikiem czasu.
class _RecordButton extends ConsumerStatefulWidget {
  const _RecordButton({required this.entryId, required this.onBusy});

  final String entryId;
  final ValueChanged<bool> onBusy;

  @override
  ConsumerState<_RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends ConsumerState<_RecordButton> {
  bool _recording = false;
  DateTime? _startedAt;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_recording) {
      return OutlinedButton.icon(
        onPressed: _start,
        icon: const Icon(Icons.mic, size: 18),
        label: const Text('Nagraj'),
      );
    }

    final elapsed = DateTime.now().difference(_startedAt!);
    final mmss = '${elapsed.inMinutes.toString().padLeft(2, '0')}:'
        '${elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: _stop,
          icon: const Icon(Icons.stop, size: 18),
          label: Text('Zatrzymaj  $mmss'),
        ),
        IconButton(
          tooltip: 'Porzuć nagranie',
          icon: const Icon(Icons.delete_outline),
          onPressed: _cancel,
        ),
      ],
    );
  }

  Future<void> _start() async {
    final capture = await ref.read(mediaCaptureProvider.future);
    final ok = await capture.startRecording();

    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Brak zgody na mikrofon — włącz ją w ustawieniach systemu.'),
        ),
      );
      return;
    }

    setState(() {
      _recording = true;
      _startedAt = DateTime.now();
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _stop() async {
    _ticker?.cancel();
    widget.onBusy(true);

    try {
      final capture = await ref.read(mediaCaptureProvider.future);
      final durationMs =
          DateTime.now().difference(_startedAt!).inMilliseconds;
      final media = await capture.stopRecording(durationMs: durationMs);

      if (media != null) {
        await ref.read(journalDaoProvider).addAttachment(
              entryId: widget.entryId,
              kind: AttachmentKind.audio,
              fileName: media.stored.fileName,
              sha256: media.stored.sha256,
              label: media.label,
              mimeType: media.stored.mimeType,
              bytes: media.stored.bytes,
              durationMs: media.durationMs,
            );
      }
    } finally {
      widget.onBusy(false);
      if (mounted) setState(() => _recording = false);
    }
  }

  Future<void> _cancel() async {
    _ticker?.cancel();
    final capture = await ref.read(mediaCaptureProvider.future);
    await capture.cancelRecording();
    if (mounted) setState(() => _recording = false);
  }
}

class _AttachmentsSection extends ConsumerWidget {
  const _AttachmentsSection({
    required this.entryId,
    required this.attachments,
  });

  final String entryId;
  final List<Attachment> attachments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final store = ref.watch(mediaStoreProvider).value;
    if (store == null) return const LinearProgressIndicator();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Załączniki',
            style: TextStyle(fontSize: 13, color: VizColors.inkMuted)),
        const SizedBox(height: 8),
        for (final a in attachments)
          AttachmentTile(
            attachment: a,
            file: store.fileFor(a.fileName),
            onDelete: () async {
              await ref.read(journalDaoProvider).softDeleteAttachment(a.id);
              if (!context.mounted) return;
              showUndoSnackBar(
                context,
                message: 'Usunięto załącznik',
                onUndo: () =>
                    ref.read(journalDaoProvider).restoreAttachment(a.id),
              );
            },
          ),
        const SizedBox(height: 8),
        Text(
          'Pliki są kopiowane do katalogu aplikacji — skasowanie '
          'oryginału w galerii niczego tu nie zepsuje.',
          style: TextStyle(fontSize: 11, color: VizColors.inkMuted),
        ),
      ],
    );
  }
}

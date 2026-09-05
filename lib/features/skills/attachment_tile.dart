import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/db/enums.dart';
import '../../core/media/media_store.dart';

/// Jeden załącznik na stronie dziennika.
class AttachmentTile extends StatelessWidget {
  const AttachmentTile({
    required this.attachment,
    required this.file,
    required this.onDelete,
    super.key,
  });

  final Attachment attachment;
  final File file;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // Wiersz istnieje, ale pliku nie ma — zdarzy się przy wpisie przyniesionym
    // z synchronizacji, zanim medium zostanie pobrane. Mówimy o tym wprost,
    // zamiast pokazywać pustą ramkę wyglądającą na błąd.
    if (!file.existsSync()) {
      return _MissingFile(attachment: attachment, onDelete: onDelete);
    }

    return switch (attachment.kind) {
      AttachmentKind.audio =>
        _AudioTile(attachment: attachment, file: file, onDelete: onDelete),
      AttachmentKind.photo =>
        _PhotoTile(attachment: attachment, file: file, onDelete: onDelete),
      AttachmentKind.video || AttachmentKind.file =>
        _FileTile(attachment: attachment, file: file, onDelete: onDelete),
    };
  }
}

/// Odtwarzacz nagrania.
///
/// Przy nauce śpiewu czy gry to najważniejszy typ załącznika — jedyny,
/// który po pół roku pokaże różnicę, jakiej notatka nie odda.
class _AudioTile extends StatefulWidget {
  const _AudioTile({
    required this.attachment,
    required this.file,
    required this.onDelete,
  });

  final Attachment attachment;
  final File file;
  final VoidCallback onDelete;

  @override
  State<_AudioTile> createState() => _AudioTileState();
}

class _AudioTileState extends State<_AudioTile> {
  AudioPlayer? _player;
  bool _loading = false;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<AudioPlayer> _ensurePlayer() async {
    final existing = _player;
    if (existing != null) return existing;

    final player = AudioPlayer();
    await player.setFilePath(widget.file.path);
    // Po dojściu do końca wracamy na początek i zatrzymujemy, żeby
    // kolejne kliknięcie odtwarzało od nowa, a nie stało w miejscu.
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        player.seek(Duration.zero);
        player.pause();
      }
    });
    return _player = player;
  }

  @override
  Widget build(BuildContext context) {
    final player = _player;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            StreamBuilder<PlayerState>(
              stream: player?.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(playing ? Icons.pause_circle : Icons.play_circle),
                  iconSize: 36,
                  onPressed: _toggle,
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.attachment.label.isEmpty
                        ? 'Nagranie'
                        : widget.attachment.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  StreamBuilder<Duration>(
                    stream: player?.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final total = player?.duration ??
                          (widget.attachment.durationMs == null
                              ? null
                              : Duration(
                                  milliseconds: widget.attachment.durationMs!));
                      return Text(
                        total == null
                            ? _mmss(position)
                            : '${_mmss(position)} / ${_mmss(total)}'
                                '  ·  ${formatBytes(widget.attachment.bytes)}',
                        style:
                            TextStyle(fontSize: 12, color: VizColors.inkMuted),
                      );
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle() async {
    setState(() => _loading = true);
    try {
      final player = await _ensurePlayer();
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static String _mmss(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:'
      '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.attachment,
    required this.file,
    required this.onDelete,
  });

  final Attachment attachment;
  final File file;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => _PhotoViewer(file: file),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: Image.file(
                file,
                width: double.infinity,
                fit: BoxFit.cover,
                // Plik może być uszkodzony albo w formacie, którego
                // Flutter nie zdekoduje — lepiej pokazać zastępczą ikonę
                // niż wywalić całą listę załączników.
                errorBuilder: (context, error, stack) => Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text(formatBytes(attachment.bytes)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: Image.file(file),
        ),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.attachment,
    required this.file,
    required this.onDelete,
  });

  final Attachment attachment;
  final File file;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isVideo = attachment.kind == AttachmentKind.video;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(isVideo ? Icons.movie_outlined : Icons.insert_drive_file),
        title: Text(
          attachment.label.isEmpty ? attachment.fileName : attachment.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${formatBytes(attachment.bytes)} · zapisane w aplikacji',
          style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _MissingFile extends StatelessWidget {
  const _MissingFile({required this.attachment, required this.onDelete});

  final Attachment attachment;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.cloud_off),
        title: Text(
          attachment.label.isEmpty ? 'Załącznik' : attachment.label,
        ),
        subtitle: Text(
          'Plik nie jest jeszcze na tym urządzeniu.',
          style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

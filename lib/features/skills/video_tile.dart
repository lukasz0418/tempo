import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../app/theme.dart';
import '../../core/db/database.dart';
import '../../core/media/media_store.dart';

/// Odtwarzacz wideo dołączonego do wpisu.
///
/// Tylko Android — oficjalna wtyczka `video_player` nie ma implementacji
/// dla Windowsa. Na desktopie [AttachmentTile] pokazuje zamiast tego
/// kafelek z informacją o pliku, zamiast czarnego prostokąta,
/// który wyglądałby na zepsuty.
class VideoTile extends StatefulWidget {
  const VideoTile({
    required this.attachment,
    required this.file,
    required this.onDelete,
    super.key,
  });

  final Attachment attachment;
  final File file;
  final VoidCallback onDelete;

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  VideoPlayerController? _controller;
  bool _initializing = false;
  String? _error;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Kontroler tworzony dopiero przy pierwszym odtworzeniu.
  ///
  /// Wpis z pięcioma nagraniami inicjalizowałby pięć dekoderów naraz
  /// przy samym otwarciu strony — a telefon ma ich ograniczoną pulę
  /// i szósty po prostu się nie uruchamia.
  Future<void> _ensureController() async {
    if (_controller != null) return;

    setState(() => _initializing = true);
    try {
      final controller = VideoPlayerController.file(widget.file);
      await controller.initialize();
      await controller.setLooping(false);
      controller.addListener(_onTick);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (e) {
      if (mounted) setState(() => _error = 'Nie udało się otworzyć nagrania.');
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  void _onTick() {
    if (!mounted) return;

    // Błąd potrafi pojawić się długo PO udanej inicjalizacji — dekoder
    // przyjmuje plik, a wywraca się dopiero na pierwszej klatce
    // (nieobsługiwany profil, nietypowa rozdzielczość). Bez tego
    // sprawdzenia użytkownik dostaje zamrożony czarny prostokąt
    // bez słowa wyjaśnienia.
    final error = _controller?.value.errorDescription;
    if (error != null && _error == null) {
      setState(() {
        _error = 'To urządzenie nie odtworzy tego formatu.';
        _controller?.removeListener(_onTick);
      });
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Przy błędzie wracamy do miejsca na podgląd zamiast pokazywać
          // odtwarzacz, który i tak nic nie wyświetli.
          if (controller != null &&
              controller.value.isInitialized &&
              _error == null)
            _buildPlayer(controller)
          else
            _buildPlaceholder(),
          ListTile(
            dense: true,
            title: Text(
              widget.attachment.label.isEmpty
                  ? 'Wideo'
                  : widget.attachment.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              _error ?? formatBytes(widget.attachment.bytes),
              style: TextStyle(
                fontSize: 12,
                color: _error == null
                    ? VizColors.inkMuted
                    : const Color(0xFFD03B3B),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: widget.onDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black12,
        child: Center(
          child: switch ((_initializing, _error)) {
            (true, _) => const CircularProgressIndicator(),
            (_, final String _) => const Icon(
                Icons.videocam_off_outlined,
                size: 48,
                color: Colors.black38,
              ),
            _ => IconButton(
                iconSize: 56,
                icon: const Icon(Icons.play_circle_outline),
                onPressed: () async {
                  await _ensureController();
                  await _controller?.play();
                },
              ),
          },
        ),
      ),
    );
  }

  Widget _buildPlayer(VideoPlayerController controller) {
    final value = controller.value;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: value.aspectRatio,
          child: GestureDetector(
            onTap: () =>
                value.isPlaying ? controller.pause() : controller.play(),
            child: VideoPlayer(controller),
          ),
        ),
        Container(
          color: Colors.black45,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                color: Colors.white,
                icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () =>
                    value.isPlaying ? controller.pause() : controller.play(),
              ),
              Expanded(
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_mmss(value.position)} / ${_mmss(value.duration)}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _mmss(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:'
      '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}

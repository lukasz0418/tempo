import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/db/daos/settings_dao.dart';
import '../../core/tracking/android_usage.dart';
import '../../core/update/update_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _UpdateCard(),
        SizedBox(height: 16),
        _TrackingCard(),
        SizedBox(height: 16),
        _AboutCard(),
      ],
    );
  }
}

/// Aktualizacje aplikacji na telefonie.
///
/// Aplikacja nie chodzi przez sklep, więc aktualizacja to pobranie nowego
/// APK i oddanie go systemowemu instalatorowi. Adres manifestu jest
/// ustawieniem, a nie stałą w kodzie — dzięki temu można przełączyć się
/// z GitHub Releases na własny serwer bez przebudowywania aplikacji.
class _UpdateCard extends ConsumerStatefulWidget {
  const _UpdateCard();

  @override
  ConsumerState<_UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends ConsumerState<_UpdateCard> {
  final _urlController = TextEditingController();
  bool _loadedUrl = false;
  double? _progress;
  bool _downloading = false;
  String? _error;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storedUrl = ref.watch(updateManifestUrlProvider).value;
    if (!_loadedUrl && storedUrl != null) {
      _loadedUrl = true;
      _urlController.text = storedUrl;
    }

    final check = ref.watch(updateCheckProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aktualizacje', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              Platform.isAndroid
                  ? 'Aplikacja sprawdza manifest i instaluje nowy APK.'
                  : 'Instalacja przez APK działa tylko na Androidzie. '
                      'Na PC aktualizujesz przez przebudowanie projektu.',
              style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Adres manifestu (https://)',
                hintText: 'https://github.com/.../releases/latest/download/update.json',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: _saveUrl,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () => _saveUrl(_urlController.text),
                  child: const Text('Zapisz adres'),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => ref.invalidate(updateCheckProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Sprawdź'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Color(0xFFD03B3B))),
              const SizedBox(height: 12),
            ],
            if (_downloading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gdy serwer nie poda długości treści, pasek przechodzi
                  // w tryb nieokreślony zamiast udawać, że stoi na zerze.
                  LinearProgressIndicator(value: _progress),
                  const SizedBox(height: 8),
                  Text(
                    _progress == null
                        ? 'Pobieranie…'
                        : 'Pobrano ${(_progress! * 100).round()}%',
                    style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
                  ),
                ],
              )
            else
              check.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Błąd sprawdzania: $e'),
                data: (result) => _buildStatus(result),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(UpdateCheck? result) {
    if (result == null) {
      return Text(
        'Podaj adres manifestu, żeby włączyć aktualizacje.',
        style: TextStyle(fontSize: 13, color: VizColors.inkMuted),
      );
    }

    return switch (result) {
      UpToDate(:final currentCode) => Row(
          children: [
            const Icon(Icons.check_circle_outline,
                size: 18, color: Color(0xFF0CA30C)),
            const SizedBox(width: 8),
            Text('Masz najnowszą wersję (build $currentCode).'),
          ],
        ),
      UpdateCheckFailed(:final reason) => Row(
          children: [
            const Icon(Icons.error_outline, size: 18, color: Color(0xFFD03B3B)),
            const SizedBox(width: 8),
            Expanded(child: Text(reason)),
          ],
        ),
      UpdateAvailable(:final manifest, :final needsManualInstall) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dostępna wersja ${manifest.versionName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (manifest.notes != null) ...[
              const SizedBox(height: 4),
              Text(manifest.notes!,
                  style: TextStyle(fontSize: 12, color: VizColors.inkMuted)),
            ],
            const SizedBox(height: 12),
            if (needsManualInstall)
              Text(
                'Ta wersja wymaga ręcznej instalacji — prawdopodobnie '
                'zmienił się klucz podpisujący.',
                style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
              )
            else
              FilledButton.icon(
                onPressed: () => _install(manifest),
                icon: const Icon(Icons.download),
                label: const Text('Pobierz i zainstaluj'),
              ),
          ],
        ),
    };
  }

  Future<void> _saveUrl(String url) async {
    await ref
        .read(settingsDaoProvider)
        .set(SettingKeys.updateManifestUrl, url.trim());
    ref.invalidate(updateCheckProvider);
  }

  Future<void> _install(UpdateManifest manifest) async {
    final service = ref.read(updateServiceProvider);

    // Bez tej zgody instalator wystartuje i od razu odbije się od systemu,
    // co wygląda jak zawieszenie aplikacji.
    if (!await service.canInstall()) {
      await service.requestInstallPermission();
      if (!mounted) return;
      setState(() => _error =
          'Włącz „Instalowanie nieznanych aplikacji" dla Tempo i spróbuj ponownie.');
      return;
    }

    setState(() {
      _downloading = true;
      _error = null;
      _progress = 0;
    });

    final error = await service.downloadAndInstall(
      manifest,
      onProgress: (p) {
        if (mounted) setState(() => _progress = p);
      },
    );

    if (!mounted) return;
    setState(() {
      _downloading = false;
      _error = error;
    });
  }
}

class _TrackingCard extends ConsumerStatefulWidget {
  const _TrackingCard();

  @override
  ConsumerState<_TrackingCard> createState() => _TrackingCardState();
}

class _TrackingCardState extends ConsumerState<_TrackingCard> {
  bool? _hasUsagePermission;

  @override
  void initState() {
    super.initState();
    _refreshPermission();
  }

  Future<void> _refreshPermission() async {
    if (!Platform.isAndroid) return;
    final has = await AndroidUsageTracker().hasPermission();
    if (mounted) setState(() => _hasUsagePermission = has);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Śledzenie aktywności',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              Platform.isWindows
                  ? 'Windows odczytuje aktywne okno co 5 sekund. '
                      'Żadne uprawnienia nie są potrzebne.'
                  : 'Android czyta historię użycia aplikacji. Wymaga zgody '
                      '„Dostęp do danych o użyciu", której nie da się '
                      'przyznać zwykłym dialogiem.',
              style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
            ),
            if (Platform.isAndroid) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    _hasUsagePermission == true
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    size: 18,
                    color: _hasUsagePermission == true
                        ? const Color(0xFF0CA30C)
                        : const Color(0xFFD03B3B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_hasUsagePermission == true
                        ? 'Zgoda przyznana'
                        : 'Brak zgody — statystyki będą puste'),
                  ),
                  if (_hasUsagePermission != true)
                    TextButton(
                      onPressed: () async {
                        await AndroidUsageTracker().requestPermission();
                        await _refreshPermission();
                      },
                      child: const Text('Otwórz ustawienia'),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final changed =
                    await ref.read(trackingServiceProvider).reclassifyAll();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Przeklasyfikowano $changed bloków')),
                );
              },
              icon: const Icon(Icons.rule),
              label: const Text('Przelicz klasyfikację na nowo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends ConsumerWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceId = ref.watch(deviceIdProvider).value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To urządzenie',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'ID: ${deviceId ?? '—'}',
              style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
            ),
            Text(
              'Platforma: ${Platform.operatingSystem}',
              style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

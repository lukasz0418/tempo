import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/review/day_review.dart';
import '../../core/util/dates.dart';

/// Wieczorne rozliczenie dnia.
///
/// Podzielone na dwie części, które robią co innego:
///  * **werdykt** — liczony automatycznie z pomiaru, nie do podważenia;
///  * **twoje słowa** — trzy pytania, na które odpowiadasz sam.
///
/// Bez tej pierwszej części podsumowanie jest pamiętnikiem i po tygodniu
/// przestaje być wypełniane. Bez drugiej jest suchym raportem, z którego
/// nic nie wynika.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verdict = ref.watch(dayVerdictProvider);
    final day = ref.watch(selectedDayProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DaySwitcher(day: day),
        const SizedBox(height: 16),
        verdict.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text('Nie udało się policzyć podsumowania: $e'),
          data: (v) => _VerdictCard(verdict: v),
        ),
        const SizedBox(height: 16),
        _OwnWordsCard(dayKey: dayKey(day)),
      ],
    );
  }
}

class _DaySwitcher extends ConsumerWidget {
  const _DaySwitcher({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToday = dayKey(day) == todayKey();

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => ref.read(selectedDayProvider.notifier).shift(-1),
        ),
        Expanded(
          child: Text(
            isToday ? 'Dzisiaj' : dayKey(day),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          // Blokada wyprzedzania „dzisiaj" — podsumowanie przyszłego dnia
          // nie miałoby z czego powstać.
          icon: const Icon(Icons.chevron_right),
          onPressed:
              isToday ? null : () => ref.read(selectedDayProvider.notifier).shift(1),
        ),
      ],
    );
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.verdict});

  final DayVerdict verdict;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verdict.headline,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            if (verdict.wins.isNotEmpty)
              _NoteGroup(
                title: 'Co poszło dobrze',
                notes: verdict.wins,
                icon: Icons.check_circle_outline,
                // Kolor statusu nigdy nie występuje sam — zawsze
                // z ikoną i podpisem grupy.
                color: const Color(0xFF0CA30C),
              ),
            if (verdict.problems.isNotEmpty) ...[
              const SizedBox(height: 16),
              _NoteGroup(
                title: 'Co nie wyszło',
                notes: verdict.problems,
                icon: Icons.error_outline,
                color: const Color(0xFFD03B3B),
              ),
            ],
            if (verdict.observations.isNotEmpty) ...[
              const SizedBox(height: 16),
              _NoteGroup(
                title: 'Warte odnotowania',
                notes: verdict.observations,
                icon: Icons.info_outline,
                color: VizColors.inkMuted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoteGroup extends StatelessWidget {
  const _NoteGroup({
    required this.title,
    required this.notes,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<ReviewNote> notes;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: VizColors.inkSecondary(brightness),
          ),
        ),
        const SizedBox(height: 8),
        for (final note in notes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.text,
                        // Tekst w tokenie tekstowym, nie w kolorze statusu —
                        // znaczenie niesie ikona obok.
                        style: TextStyle(color: VizColors.ink(brightness)),
                      ),
                      if (note.detail != null)
                        Text(
                          note.detail!,
                          style: TextStyle(
                            fontSize: 12,
                            color: VizColors.inkMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Trzy pytania własnymi słowami plus ocena dnia.
class _OwnWordsCard extends ConsumerStatefulWidget {
  const _OwnWordsCard({required this.dayKey});

  final String dayKey;

  @override
  ConsumerState<_OwnWordsCard> createState() => _OwnWordsCardState();
}

class _OwnWordsCardState extends ConsumerState<_OwnWordsCard> {
  final _wins = TextEditingController();
  final _struggles = TextEditingController();
  final _change = TextEditingController();
  int? _mood;
  String? _loadedFor;

  @override
  void dispose() {
    _wins.dispose();
    _struggles.dispose();
    _change.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(dayPlanProvider).value;

    // Przeładowanie pól przy zmianie dnia. Warunek na [_loadedFor] jest
    // konieczny, żeby nie nadpisywać tekstu w trakcie pisania przy każdym
    // przebudowaniu widoku.
    if (_loadedFor != widget.dayKey) {
      _loadedFor = widget.dayKey;
      _wins.text = plan?.wins ?? '';
      _struggles.text = plan?.struggles ?? '';
      _change.text = plan?.changeTomorrow ?? '';
      _mood = plan?.moodEnd;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Twoimi słowami',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _Field(
              controller: _wins,
              label: 'Co dziś zrobiłem dobrze?',
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _struggles,
              label: 'Co nie wyszło i dlaczego?',
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _change,
              label: 'Jedna rzecz do zmiany jutro',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Text('Ocena dnia',
                style: TextStyle(fontSize: 13, color: VizColors.inkMuted)),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$i'),
                      selected: _mood == i,
                      onSelected: (_) => setState(() => _mood = i),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Zamknij dzień'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    await ref.read(insightDaoProvider).saveDayPlan(
          widget.dayKey,
          wins: _wins.text.trim(),
          struggles: _struggles.text.trim(),
          changeTomorrow: _change.text.trim(),
          moodEnd: _mood,
          markReviewed: true,
        );
    ref.invalidate(dayPlanProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dzień zamknięty')),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 3,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }
}

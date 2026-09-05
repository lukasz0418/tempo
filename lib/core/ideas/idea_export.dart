import '../db/database.dart';
import '../db/enums.dart';

/// Zamienia tablicę pomysłów w Markdown gotowy do wklejenia w rozmowę
/// z asystentem.
///
/// Eksport zaczyna się od krótkiego opisu projektu, a nie od samej listy.
/// Powód jest praktyczny: wklejasz to zwykle w **nową** rozmowę, która nie zna
/// ani stacku, ani tego, co już działa. Bez tego nagłówka pierwsza odpowiedź
/// to zawsze seria pytań, na które zdążyłeś już odpowiedzieć w poprzedniej.
abstract final class IdeaExporter {
  /// Nagłówek z kontekstem technicznym. Jedno miejsce do zmiany,
  /// gdy projekt się rozjedzie z opisem.
  static const projectContext = '''
Projekt: **Tempo** — prywatna aplikacja do zarządzania czasem i zadaniami.

- Flutter (Android + Windows desktop), stan przez Riverpod
- Lokalny SQLite przez drift jako źródło prawdy; schemat przygotowany pod
  synchronizację last-write-wins (UUID z klienta, `updated_at`, tombstone `deleted`, flaga `dirty`)
- Automatyczne śledzenie aktywności: Windows przez `dart:ffi` (aktywne okno +
  bezczynność), Android przez `UsageStatsManager`
- Czas klasyfikowany regułami na cztery klasy: produktywny / neutralny /
  odpoczynek / rozpraszacz
- Zadania mają estymaty jako zakres; aplikacja liczy „współczynnik optymizmu"
  z historii i koryguje podpowiedzi
''';

  static String export(
    List<Idea> ideas, {
    bool includeContext = true,
    bool onlyOpen = true,
  }) {
    final selected = onlyOpen
        ? ideas
            .where((i) =>
                i.status != IdeaStatus.done && i.status != IdeaStatus.rejected)
            .toList()
        : ideas;

    final buf = StringBuffer();

    if (includeContext) {
      buf
        ..writeln('# Tempo — pomysły i zmiany')
        ..writeln()
        ..writeln(projectContext)
        ..writeln('---')
        ..writeln();
    }

    if (selected.isEmpty) {
      buf.writeln('_Brak pomysłów do wyeksportowania._');
      return buf.toString();
    }

    // Grupowanie po rodzaju, bo błąd i pomysł na funkcję wymagają
    // zupełnie innej reakcji, a wymieszane na jednej liście
    // rozmywają się nawzajem.
    for (final kind in IdeaKind.values) {
      final group = selected.where((i) => i.kind == kind).toList();
      if (group.isEmpty) continue;

      buf
        ..writeln('## ${_kindHeading(kind)}')
        ..writeln();

      // Najpierw to, co ma największy sens robić: duży wpływ, mały koszt.
      group.sort((a, b) => _score(b).compareTo(_score(a)));

      for (final idea in group) {
        buf.write('- **${idea.title}**');

        final meta = <String>[];
        if (idea.status != IdeaStatus.inbox) {
          meta.add(_statusLabel(idea.status));
        }
        if (idea.impact != null) meta.add('wpływ ${idea.impact}/5');
        if (idea.effort != null) meta.add('koszt ${idea.effort}/5');
        if (idea.tags.isNotEmpty) meta.add(idea.tags);
        if (meta.isNotEmpty) buf.write(' _(${meta.join(', ')})_');
        buf.writeln();

        final body = idea.body?.trim();
        if (body != null && body.isNotEmpty) {
          // Wcięcie utrzymuje wielolinijkowy opis wewnątrz punktu listy.
          for (final line in body.split('\n')) {
            buf.writeln('  $line');
          }
        }
      }
      buf.writeln();
    }

    return buf.toString().trimRight();
  }

  /// Ranking „co robić najpierw": wpływ minus koszt.
  ///
  /// Pomysły bez ocen lądują pośrodku, a nie na końcu — brak oceny
  /// znaczy „jeszcze nie przemyślane", nie „nieważne".
  static int _score(Idea i) => (i.impact ?? 3) - (i.effort ?? 3);

  static String _kindHeading(IdeaKind kind) => switch (kind) {
        IdeaKind.feature => 'Nowe funkcje',
        IdeaKind.change => 'Zmiany w istniejących',
        IdeaKind.bug => 'Błędy',
        IdeaKind.question => 'Pytania i wątpliwości',
      };

  static String _statusLabel(IdeaStatus status) => switch (status) {
        IdeaStatus.inbox => 'nowe',
        IdeaStatus.considering => 'do przemyślenia',
        IdeaStatus.planned => 'zaplanowane',
        IdeaStatus.done => 'zrobione',
        IdeaStatus.rejected => 'odrzucone',
      };
}

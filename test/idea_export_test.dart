import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/db/database.dart';
import 'package:tempo/core/db/enums.dart';
import 'package:tempo/core/ideas/idea_export.dart';

Idea idea({
  required String title,
  String? body,
  IdeaKind kind = IdeaKind.feature,
  IdeaStatus status = IdeaStatus.inbox,
  int? impact,
  int? effort,
  String tags = '',
}) {
  final now = DateTime.utc(2026, 3, 10);
  return Idea(
    id: title,
    title: title,
    body: body,
    kind: kind,
    status: status,
    impact: impact,
    effort: effort,
    tags: tags,
    createdAt: now,
    updatedAt: now,
    deleted: false,
    dirty: true,
  );
}

void main() {
  group('IdeaExporter', () {
    test('nagłówek niesie kontekst projektu', () {
      // Eksport trafia zwykle do NOWEJ rozmowy, która nie zna ani stacku,
      // ani tego, co już działa. Bez tego opisu pierwsza odpowiedź
      // to zawsze seria pytań.
      final markdown = IdeaExporter.export([idea(title: 'Cokolwiek')]);

      expect(markdown, contains('Flutter'));
      expect(markdown, contains('drift'));
      expect(markdown, contains('Cokolwiek'));
    });

    test('pomija zrobione i odrzucone', () {
      final markdown = IdeaExporter.export([
        idea(title: 'Otwarte'),
        idea(title: 'Zrobione', status: IdeaStatus.done),
        idea(title: 'Odrzucone', status: IdeaStatus.rejected),
      ]);

      expect(markdown, contains('Otwarte'));
      expect(markdown, isNot(contains('Zrobione')));
      expect(markdown, isNot(contains('Odrzucone')));
    });

    test('onlyOpen: false bierze wszystko', () {
      final markdown = IdeaExporter.export(
        [idea(title: 'Zrobione', status: IdeaStatus.done)],
        onlyOpen: false,
      );

      expect(markdown, contains('Zrobione'));
    });

    test('grupuje po rodzaju', () {
      final markdown = IdeaExporter.export([
        idea(title: 'Nowa rzecz'),
        idea(title: 'Coś się psuje', kind: IdeaKind.bug),
      ]);

      expect(markdown, contains('## Nowe funkcje'));
      expect(markdown, contains('## Błędy'));
    });

    test('w grupie najpierw duży wpływ przy małym koszcie', () {
      final markdown = IdeaExporter.export([
        idea(title: 'Drogie i mało warte', impact: 1, effort: 5),
        idea(title: 'Tanie i cenne', impact: 5, effort: 1),
      ]);

      expect(
        markdown.indexOf('Tanie i cenne'),
        lessThan(markdown.indexOf('Drogie i mało warte')),
      );
    });

    test('wielolinijkowy opis zostaje wewnątrz punktu listy', () {
      final markdown = IdeaExporter.export([
        idea(title: 'Z opisem', body: 'pierwsza\ndruga'),
      ]);

      expect(markdown, contains('  pierwsza'));
      expect(markdown, contains('  druga'));
    });

    test('pusta lista daje czytelny komunikat, nie pusty plik', () {
      final markdown = IdeaExporter.export([]);

      expect(markdown, contains('Brak pomysłów'));
    });

    test('bez kontekstu zaczyna się od pierwszej grupy', () {
      final markdown = IdeaExporter.export(
        [idea(title: 'Coś')],
        includeContext: false,
      );

      expect(markdown, isNot(contains('Flutter')));
      expect(markdown.trimLeft(), startsWith('## Nowe funkcje'));
    });
  });
}

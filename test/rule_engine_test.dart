import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/db/enums.dart';
import 'package:tempo/core/tracking/rule_engine.dart';

void main() {
  group('RuleEngine', () {
    test('dopasowuje po nazwie aplikacji', () {
      final engine = RuleEngine([
        const Rule(
          id: 'steam',
          pattern: 'steam.exe',
          productivity: Productivity.distraction,
        ),
      ]);

      final result = engine.classify(const ActivitySample(appId: 'steam.exe'));

      expect(result.productivity, Productivity.distraction);
      expect(result.ruleId, 'steam');
    });

    test('ignoruje wielkość liter poza wyrażeniem regularnym', () {
      final engine = RuleEngine([
        const Rule(
          id: 'code',
          pattern: 'code.exe',
          productivity: Productivity.productive,
        ),
      ]);

      expect(
        engine.classify(const ActivitySample(appId: 'Code.exe')).productivity,
        Productivity.productive,
      );
    });

    test('reguła na tytule okna bije regułę na aplikacji', () {
      // To jest sedno całej klasyfikacji: ta sama przeglądarka jest raz
      // pracą, a raz rozpraszaczem — rozstrzyga wyłącznie tytuł.
      final engine = RuleEngine([
        const Rule(
          id: 'chrome',
          pattern: 'chrome.exe',
          productivity: Productivity.productive,
          priority: 50,
        ),
        const Rule(
          id: 'yt',
          pattern: 'YouTube',
          productivity: Productivity.distraction,
          matchTarget: MatchTarget.windowTitle,
          priority: 100,
        ),
      ]);

      final work = engine.classify(const ActivitySample(
        appId: 'chrome.exe',
        windowTitle: 'drift docs - Chrome',
      ));
      final waste = engine.classify(const ActivitySample(
        appId: 'chrome.exe',
        windowTitle: 'koty kompilacja - YouTube - Chrome',
      ));

      expect(work.productivity, Productivity.productive);
      expect(waste.productivity, Productivity.distraction);
    });

    test('przy równym priorytecie wygrywa dłuższy wzorzec', () {
      final engine = RuleEngine([
        const Rule(
          id: 'family',
          pattern: 'com.supercell.',
          productivity: Productivity.distraction,
          matchType: MatchType.startsWith,
        ),
        const Rule(
          id: 'specific',
          pattern: 'com.supercell.clashroyale',
          productivity: Productivity.leisure,
          matchType: MatchType.startsWith,
        ),
      ]);

      final result = engine
          .classify(const ActivitySample(appId: 'com.supercell.clashroyale'));

      expect(result.ruleId, 'specific');
    });

    test('reguła platformowa nie łapie innej platformy', () {
      final engine = RuleEngine([
        const Rule(
          id: 'win-only',
          pattern: 'steam',
          productivity: Productivity.distraction,
          platform: DevicePlatform.windows,
        ),
      ]);

      final onAndroid = engine.classify(const ActivitySample(
        appId: 'com.valvesoftware.steam',
        platform: DevicePlatform.android,
      ));

      expect(onAndroid.productivity, Productivity.unknown);
    });

    test('wyłączona reguła jest pomijana', () {
      final engine = RuleEngine([
        const Rule(
          id: 'off',
          pattern: 'steam.exe',
          productivity: Productivity.distraction,
          enabled: false,
        ),
      ]);

      expect(
        engine.classify(const ActivitySample(appId: 'steam.exe')).productivity,
        Productivity.unknown,
      );
    });

    test('zepsuty regex wyłącza tylko swoją regułę', () {
      // Wzorce pisze użytkownik. Jeden zły nawias nie może położyć
      // pomiaru w tle dla wszystkiego pozostałego.
      final engine = RuleEngine([
        const Rule(
          id: 'broken',
          pattern: '([unclosed',
          productivity: Productivity.distraction,
          matchType: MatchType.regex,
          priority: 999,
        ),
        const Rule(
          id: 'good',
          pattern: 'code.exe',
          productivity: Productivity.productive,
        ),
      ]);

      expect(engine.brokenRuleIds, contains('broken'));
      expect(
        engine.classify(const ActivitySample(appId: 'code.exe')).productivity,
        Productivity.productive,
      );
    });

    test('brak dopasowania daje unknown', () {
      final engine = RuleEngine(const []);

      expect(
        engine.classify(const ActivitySample(appId: 'cokolwiek.exe')).isUnknown,
        isTrue,
      );
    });
  });
}

import '../db/enums.dart';

/// Aktywność do zaklasyfikowania.
class ActivitySample {
  const ActivitySample({
    required this.appId,
    this.windowTitle,
    this.platform = DevicePlatform.unknown,
  });

  /// `chrome.exe` albo `com.google.android.youtube`.
  final String appId;

  /// Na Androidzie prawie zawsze null — system nie udostępnia
  /// tytułu bez usług dostępności, a te są zbyt inwazyjne jak na tę aplikację.
  final String? windowTitle;

  final DevicePlatform platform;
}

/// Reguła w postaci niezależnej od bazy.
///
/// Silnik świadomie nie zna typów wygenerowanych przez drift: dzięki temu
/// da się go testować bez codegenu i bez SQLite, a logika dopasowania
/// jest jedną czystą funkcją zamiast zapytania rozsmarowanego po DAO.
class Rule {
  const Rule({
    required this.id,
    required this.pattern,
    required this.productivity,
    this.matchTarget = MatchTarget.appId,
    this.matchType = MatchType.contains,
    this.platform,
    this.categoryId,
    this.priority = 0,
    this.enabled = true,
  });

  final String id;
  final String pattern;
  final Productivity productivity;
  final MatchTarget matchTarget;
  final MatchType matchType;

  /// Null = pasuje na każdej platformie.
  final DevicePlatform? platform;
  final String? categoryId;
  final int priority;
  final bool enabled;
}

/// Wynik klasyfikacji.
class Classification {
  const Classification({
    required this.productivity,
    this.ruleId,
    this.categoryId,
  });

  /// Nic nie pasowało — aktywność trafia do przeglądu.
  static const unknown = Classification(productivity: Productivity.unknown);

  final Productivity productivity;
  final String? ruleId;
  final String? categoryId;

  bool get isUnknown => ruleId == null;
}

/// Dopasowuje aktywność do reguł.
///
/// Kolejność rozstrzygania:
///  1. wyższy `priority`,
///  2. przy remisie — dłuższy wzorzec (bardziej szczegółowy wygrywa,
///     więc `com.supercell.clashroyale` bije `com.supercell.`),
///  3. przy dalszym remisie — `id`, żeby wynik był deterministyczny
///     i ta sama próbka nie dostawała różnych etykiet przy dwóch przebiegach.
///
/// Silnik jest tworzony raz na zestaw reguł i przelicza sortowanie oraz
/// kompiluje wyrażenia regularne w konstruktorze — `classify` leci na gorącej
/// ścieżce co kilka sekund i nie może kompilować regexów za każdym razem.
class RuleEngine {
  RuleEngine(List<Rule> rules)
      : _rules = _sorted(rules.where((r) => r.enabled).toList()) {
    for (final r in _rules) {
      if (r.matchType != MatchType.regex) continue;
      try {
        _regexCache[r.id] = RegExp(r.pattern);
      } on FormatException {
        // Wzorzec pisany ręcznie przez użytkownika. Zły regex ma wyłączyć
        // jedną regułę, a nie wysypać cały pomiar w tle.
        _broken.add(r.id);
      }
    }
  }

  final List<Rule> _rules;
  final Map<String, RegExp> _regexCache = {};
  final Set<String> _broken = {};

  /// Reguły z niepoprawnym wyrażeniem regularnym — ekran ustawień
  /// pokazuje je jako błędne, zamiast milczeć.
  Set<String> get brokenRuleIds => Set.unmodifiable(_broken);

  static List<Rule> _sorted(List<Rule> rules) {
    final copy = [...rules];
    copy.sort((a, b) {
      final byPriority = b.priority.compareTo(a.priority);
      if (byPriority != 0) return byPriority;
      final byLength = b.pattern.length.compareTo(a.pattern.length);
      if (byLength != 0) return byLength;
      return a.id.compareTo(b.id);
    });
    return List.unmodifiable(copy);
  }

  Classification classify(ActivitySample sample) {
    for (final rule in _rules) {
      if (_broken.contains(rule.id)) continue;
      if (rule.platform != null &&
          rule.platform != sample.platform &&
          sample.platform != DevicePlatform.unknown) {
        continue;
      }
      if (!_matches(rule, sample)) continue;

      return Classification(
        productivity: rule.productivity,
        ruleId: rule.id,
        categoryId: rule.categoryId,
      );
    }
    return Classification.unknown;
  }

  bool _matches(Rule rule, ActivitySample sample) {
    final title = sample.windowTitle;
    return switch (rule.matchTarget) {
      MatchTarget.appId => _test(rule, sample.appId),
      MatchTarget.windowTitle => title != null && _test(rule, title),
      MatchTarget.either =>
        _test(rule, sample.appId) || (title != null && _test(rule, title)),
    };
  }

  bool _test(Rule rule, String value) {
    if (rule.matchType == MatchType.regex) {
      return _regexCache[rule.id]?.hasMatch(value) ?? false;
    }

    // Wielkość liter ignorowana wszędzie poza regexem: nikt nie chce
    // pamiętać, czy proces nazywa się `Code.exe` czy `code.exe`,
    // a Windows i tak traktuje to zamiennie. W regexie zostawiamy
    // kontrolę użytkownikowi — od tego jest flaga `(?i)`.
    final v = value.toLowerCase();
    final p = rule.pattern.toLowerCase();
    return switch (rule.matchType) {
      MatchType.equals => v == p,
      MatchType.contains => v.contains(p),
      MatchType.startsWith => v.startsWith(p),
      MatchType.regex => false, // obsłużone wyżej
    };
  }
}

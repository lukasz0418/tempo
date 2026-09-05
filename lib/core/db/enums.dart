/// Wszystkie enumy trzymane są w bazie jako tekst (drift `textEnum`).
///
/// Tekst zamiast indeksu jest tu celowy: kolumny są czytelne przy ręcznym
/// zaglądaniu do SQLite i — co ważniejsze — dopisanie nowej wartości w środku
/// enuma nie przestawia znaczenia istniejących wierszy. Przy synchronizacji
/// z Postgresem po drugiej stronie stoją te same stringi.
library;

/// Jak oceniamy dany kawałek czasu.
///
/// Świadomie rozdzielone [leisure] i [distraction]. Obejrzany film to nie to
/// samo co dwie godziny, które wyparowały — jeśli wrzucić jedno i drugie do
/// worka „zmarnowane", statystyki zaczynają kłamać i przestaje się im ufać.
enum Productivity {
  /// Praca, nauka, obowiązki — czas, który realnie coś pchnął do przodu.
  productive,

  /// Ani plus, ani minus: jedzenie, dojazd, sprzątanie biurka.
  neutral,

  /// Świadomy odpoczynek. Zaplanowany serial czy granie to nie porażka.
  leisure,

  /// Czas, którego nie chciałeś oddać. Scrollowanie, autoplay, „jeszcze jeden".
  distraction,

  /// Nie zaklasyfikowano — brak pasującej reguły, czeka na decyzję.
  unknown;

  bool get isCounted => this != Productivity.unknown;
}

/// Cykl życia zadania.
enum TaskStatus {
  /// Wrzucone na szybko, jeszcze nieprzemyślane.
  inbox,
  todo,
  doing,
  done,

  /// Porzucone świadomie. Osobno od [done], żeby nie zawyżać statystyk.
  dropped;

  bool get isOpen => this == TaskStatus.inbox || this == TaskStatus.todo || this == TaskStatus.doing;
}

/// Rodzaj energii, jakiej zadanie wymaga.
///
/// Praktyczniejsze od priorytetu: o 22:00 nie filtrujesz listy po „ważności",
/// tylko po tym, na co masz jeszcze siłę.
enum EnergyKind {
  /// Wymaga skupienia i nieprzerwanego bloku.
  focus,

  /// Bezmyślne, można robić zmęczonym.
  shallow,

  /// Wymaga rozmowy z kimś, telefonu, maila.
  social,

  /// Fizyczne — sprzątanie, zakupy, siłownia.
  physical,
}

/// Gdzie/czym trzeba być, żeby to zrobić.
enum TaskContext { computer, phone, home, errand, anywhere }

/// Skąd wziął się wpis czasu.
enum TimeEntrySource {
  /// Stoper uruchomiony w aplikacji.
  timer,

  /// Wpisane ręcznie, zwykle wstecz.
  manual,

  /// Powstało z automatycznie wykrytej aktywności ([AppUsages]).
  autoImport,
}

/// Typ wpisu na tablicy pomysłów.
enum IdeaKind { feature, change, bug, question }

/// Status pomysłu. [exported] nie istnieje — od tego jest `exportedAt`,
/// bo pomysł można wyeksportować wielokrotnie, a status ma być o decyzji.
enum IdeaStatus { inbox, considering, planned, done, rejected }

/// Do czego reguła przykłada wzorzec.
enum MatchTarget {
  /// Identyfikator aplikacji: `chrome.exe`, `com.google.android.youtube`.
  appId,

  /// Tytuł okna. Na Windowsie zawiera tytuł strony, więc pozwala odróżnić
  /// YouTube z kursem od YouTube ze Shortsami.
  windowTitle,

  /// Dopasowanie, jeśli trafi którekolwiek z powyższych.
  either,
}

enum MatchType { equals, contains, startsWith, regex }

/// Platforma urządzenia — reguły bywają platformowe
/// (`chrome.exe` kontra `com.android.chrome`).
enum DevicePlatform { windows, android, unknown }

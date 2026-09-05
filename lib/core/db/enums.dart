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

/// Jakość nagrań głosowych.
///
/// Trzy ustawienia zamiast jednej stałej, bo notatka „pamiętać o kciuku"
/// i nagranie zwrotki mają zupełnie inne wymagania. Dobór wartości wynika
/// z tego, co słychać, a nie z tego, co ładnie wygląda w tabelce:
/// 64 kbps wystarcza dla mowy, ale na śpiewie słychać już artefakty
/// na wybrzmieniach — czyli dokładnie tam, gdzie chcesz usłyszeć postęp.
enum AudioQuality {
  /// 64 kbps mono — notatka mówiona. ~0,5 MB na minutę.
  note,

  /// 128 kbps mono — ćwiczenie. Domyślne. ~1 MB na minutę.
  ///
  /// Przy nagraniu własnego głosu mikrofonem telefonu to próg, powyżej
  /// którego kodek przestaje być wąskim gardłem — dalsze podnoszenie
  /// bitrate'u poprawia już tylko to, czego mikrofon i tak nie zarejestrował.
  practice,

  /// 192 kbps stereo — gdy nagrywasz instrument albo pomieszczenie.
  /// ~1,4 MB na minutę.
  high,

  /// FLAC stereo, bezstratnie. ~5 MB na minutę.
  ///
  /// Ma sens przy porządnym mikrofonie i wtedy, gdy nagranie ma być
  /// materiałem źródłowym, a nie tylko odsłuchem: bez strat da się je
  /// później obrobić albo przekodować bez kumulowania artefaktów.
  /// Do samego porównywania „jak brzmiałem pół roku temu" [high]
  /// jest praktycznie nieodróżnialne.
  lossless;

  /// Bitrate w bitach na sekundę. Dla [lossless] tylko orientacyjny —
  /// FLAC nie ma stałej przepływności, a rzeczywisty rozmiar zależy
  /// od materiału.
  int get bitRate => switch (this) {
        AudioQuality.note => 64000,
        AudioQuality.practice => 128000,
        AudioQuality.high => 192000,
        AudioQuality.lossless => 700000,
      };

  int get channels => switch (this) {
        AudioQuality.note || AudioQuality.practice => 1,
        AudioQuality.high || AudioQuality.lossless => 2,
      };

  bool get isLossless => this == AudioQuality.lossless;

  /// Rozszerzenie pliku wynikające z użytego kodeka.
  String get fileExtension => isLossless ? '.flac' : '.m4a';

  String get label => switch (this) {
        AudioQuality.note => 'Notatka głosowa',
        AudioQuality.practice => 'Ćwiczenie',
        AudioQuality.high => 'Wysoka',
        AudioQuality.lossless => 'Bezstratna',
      };

  String get description => switch (this) {
        AudioQuality.note => '64 kbps mono — do mówionych notatek',
        AudioQuality.practice => '128 kbps mono — do śpiewu i gry',
        AudioQuality.high => '192 kbps stereo — instrument, pomieszczenie',
        AudioQuality.lossless => 'FLAC stereo — materiał źródłowy, bez strat',
      };

  /// Przybliżony rozmiar minuty nagrania.
  String get sizePerMinute {
    final bytes = bitRate * 60 / 8;
    final mb = bytes / (1024 * 1024);
    return isLossless
        ? '~${mb.toStringAsFixed(0)} MB/min'
        : '${mb.toStringAsFixed(1)} MB/min';
  }
}

/// Horyzont celu.
///
/// Rozdzielenie na dwa poziomy jest tu istotne, a nie kosmetyczne: cel
/// długoterminowy nadaje kierunek, ale nie da się go „zrobić w środę".
/// Dopiero rozbicie go na cele krótkoterminowe daje coś, co da się
/// zaplanować na najbliższy tydzień.
enum GoalHorizon {
  /// Tygodnie, najwyżej miesiąc.
  short,

  /// Miesiące albo rok.
  long,
}

/// Czym mierzymy postęp w celu.
///
/// Pierwsze trzy liczą się **automatycznie** z danych, które aplikacja
/// i tak zbiera — to one sprawiają, że cel nie wymaga pamiętania
/// o odhaczaniu i dlatego w ogóle przeżywa dłużej niż dwa tygodnie.
enum GoalMetric {
  /// Przećwiczony czas w minutach. Liczony z wpisów czasu.
  minutes,

  /// Liczba sesji. Liczona z wpisów czasu.
  sessions,

  /// Dni z rzędu. Liczone z dni, w których cokolwiek robiłeś.
  streakDays,

  /// Liczba dni ćwiczonych w oknie celu — dla nawyków typu „3× w tygodniu".
  practiceDays,

  /// Osiągnięcie zero-jedynkowe: „zaśpiewać cały utwór czysto".
  /// Nie da się go policzyć — odhaczasz ręcznie.
  milestone,

  /// Własny licznik, podbijany ręcznie („nauczyć się 12 utworów").
  custom,
}

enum GoalStatus { active, achieved, abandoned }

/// Rodzaj załącznika do wpisu w dzienniku.
enum AttachmentKind {
  /// Nagranie głosowe zrobione w aplikacji. Przy nauce śpiewu czy gry
  /// to jedyny artefakt, który naprawdę pokazuje postęp — notatka
  /// nie odtworzy tego, jak brzmiałeś trzy miesiące temu.
  audio,

  photo,
  video,

  /// Cokolwiek innego: PDF z nutami, plik projektu.
  file,
}

/// Jak radzi sobie plik załącznika poza urządzeniem, na którym powstał.
enum AttachmentSyncState {
  /// Jest tylko lokalnie.
  localOnly,

  /// Wysłany do magazynu zdalnego.
  uploaded,

  /// Wiersz przyszedł z synchronizacji, ale pliku jeszcze nie pobrano.
  ///
  /// Metadane załącznika synchronizują się razem z resztą bazy, a same
  /// pliki są duże i lecą osobno — dzięki temu otwarcie wpisu na drugim
  /// urządzeniu pokazuje od razu, że nagranie istnieje, zamiast udawać,
  /// że wpis jest pusty.
  remoteOnly,
}

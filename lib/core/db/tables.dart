import 'package:drift/drift.dart';

import 'enums.dart';

/// Kolumny, które musi mieć każda tabela biorąca udział w synchronizacji.
///
/// Model sync jest celowo najprostszy z możliwych — dla jednego użytkownika
/// na dwóch urządzeniach nie ma potrzeby CRDT ani historii operacji:
///
///  * [id] to UUID **generowany na kliencie**. Dzięki temu zadanie powstaje
///    offline od razu, bez czekania na serwer i bez późniejszego przepisywania
///    kluczy obcych.
///  * [updatedAt] rozstrzyga konflikty — wygrywa nowszy zapis (last-write-wins).
///  * [deleted] to tombstone. Bez niego usunięcie na telefonie nigdy nie
///    dotarłoby do PC: pull widzi tylko wiersze, które istnieją.
///  * [dirty] oznacza „zmienione lokalnie, jeszcze niewysłane". Czyszczone
///    dopiero po potwierdzeniu z serwera.
mixin SyncedTable on Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime()();

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Kategorie życiowe: dom, zdrowie, nauka, finanse, rozrywka...
///
/// Kategoria niesie domyślną [Productivity], ale nie jest ona wiążąca —
/// pojedynczy wpis czasu może ją nadpisać.
@TableIndex(name: 'idx_categories_updated', columns: {#updatedAt})
class Categories extends Table with SyncedTable {
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// ARGB. Trzymane jako int, żeby nie parsować stringów przy każdym renderze.
  IntColumn get color => integer()();

  /// Nazwa ikony z Material Icons; null = kropka w kolorze kategorii.
  TextColumn get icon => text().nullable()();

  TextColumn get defaultProductivity =>
      textEnum<Productivity>().withDefault(const Constant('neutral'))();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Zadania. Rdzeń części „co mam zrobić" i nośnik estymat.
@TableIndex(name: 'idx_tasks_status', columns: {#status})
@TableIndex(name: 'idx_tasks_planned', columns: {#plannedFor})
@TableIndex(name: 'idx_tasks_updated', columns: {#updatedAt})
class Tasks extends Table with SyncedTable {
  TextColumn get title => text().withLength(min: 1, max: 500)();

  TextColumn get notes => text().nullable()();

  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Podzadania. Estymaty dzieci sumują się do rodzica w widoku,
  /// ale nie są tu denormalizowane — liczone są zapytaniem.
  TextColumn get parentId => text().nullable()();

  /// Estymata jako **zakres**, nie punkt.
  ///
  /// Ludzie myślą „jakieś 30–60 minut" i wymuszanie jednej liczby
  /// tylko produkuje fałszywą precyzję. Przy szacowaniu punktowym
  /// obie kolumny dostają tę samą wartość.
  IntColumn get estimateMinSeconds => integer().nullable()();
  IntColumn get estimateMaxSeconds => integer().nullable()();

  /// Czy estymata została podpowiedziana przez aplikację i przyjęta bez zmian.
  /// Pozwala później sprawdzić, czy podpowiedzi w ogóle pomagają.
  BoolColumn get estimateWasSuggested =>
      boolean().withDefault(const Constant(false))();

  TextColumn get status =>
      textEnum<TaskStatus>().withDefault(const Constant('inbox'))();

  TextColumn get energy => textEnum<EnergyKind>().nullable()();

  TextColumn get context => textEnum<TaskContext>().nullable()();

  /// 0 = brak, wyżej = ważniejsze. Świadomie zwykły int, bez enuma —
  /// skale priorytetów i tak każdy nagina do siebie.
  IntColumn get priority => integer().withDefault(const Constant(0))();

  /// Twardy termin. Rozdzielony od [startAt], bo mieszanie tych dwóch
  /// rzeczy jest głównym powodem, dla którego listy zadań stają się nieczytelne:
  /// zadanie z terminem za miesiąc nie powinno krzyczeć dzisiaj.
  DateTimeColumn get dueAt => dateTime().nullable()();

  /// Najwcześniejszy sensowny moment startu — do tego czasu zadanie jest ukryte.
  DateTimeColumn get startAt => dateTime().nullable()();

  /// Dzień, na który zadanie jest zaplanowane, jako `YYYY-MM-DD`.
  ///
  /// Tekst, a nie DateTime, bo to jest data kalendarzowa bez strefy czasowej —
  /// przy DateTime „dzisiaj" potrafi się przesunąć po zmianie strefy,
  /// a grupowanie po dniu wymagałoby liczenia na timestampach.
  TextColumn get plannedFor => text().nullable()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Reguła powtarzania w uproszczonym RRULE (`FREQ=WEEKLY;BYDAY=MO,WE`).
  TextColumn get recurrenceRule => text().nullable()();

  /// Czy kolejne wystąpienie liczyć od **wykonania**, czy od terminu.
  ///
  /// Dla podlewania kwiatów liczy się „3 dni od ostatniego podlania",
  /// nie „co 3 dni od zawsze" — inaczej po tygodniu urlopu dostajesz
  /// pięć zaległych kopii tego samego.
  BoolColumn get recurrenceFromCompletion =>
      boolean().withDefault(const Constant(true))();

  /// Ile razy zadanie zostało przełożone na później.
  ///
  /// Nie jest ozdobą: po przekroczeniu progu aplikacja pyta wprost,
  /// czy to zadanie w ogóle ma sens. Odkładane po raz siódmy zwykle nie ma.
  IntColumn get postponedCount => integer().withDefault(const Constant(0))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Wpisy czasu — zarówno ze stopera, jak i dopisane ręcznie.
///
/// Wpis z `endedAt == null` to **trwający** pomiar. Takich wierszy powinien
/// być globalnie najwyżej jeden; pilnuje tego [TimeEntryDao], a nie baza,
/// bo przy synchronizacji dwóch urządzeń przejściowo mogą pojawić się dwa
/// i lepiej je wtedy pogodzić, niż wywalić zapis błędem.
@TableIndex(name: 'idx_entries_started', columns: {#startedAt})
@TableIndex(name: 'idx_entries_task', columns: {#taskId})
@TableIndex(name: 'idx_entries_updated', columns: {#updatedAt})
class TimeEntries extends Table with SyncedTable {
  /// Null dla wpisu bez zadania („kawa", „rozmowa z mamą").
  TextColumn get taskId => text().nullable().references(Tasks, #id)();

  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Ćwiczona umiejętność, jeśli ta sesja czemuś takiemu służyła.
  ///
  /// Dzięki temu godziny ćwiczeń liczą się same z istniejącego pomiaru
  /// czasu — sesja śpiewania to zwykły wpis czasu, który dodatkowo
  /// ma stronę w dzienniku.
  TextColumn get skillId => text().nullable().references(Skills, #id)();

  TextColumn get description => text().withDefault(const Constant(''))();

  DateTimeColumn get startedAt => dateTime()();

  /// Null = stoper wciąż chodzi.
  DateTimeColumn get endedAt => dateTime().nullable()();

  /// Nadpisanie klasyfikacji dla tego konkretnego wpisu.
  /// Null = weź z kategorii albo z reguł.
  TextColumn get productivity => textEnum<Productivity>().nullable()();

  /// Samopoczucie po zadaniu, 1–5.
  ///
  /// Po miesiącu to najbardziej zaskakujące dane w całej aplikacji: pokazuje,
  /// które „produktywne" rzeczy tak naprawdę cię wypalają.
  IntColumn get moodAfter => integer().nullable()();

  IntColumn get energyAfter => integer().nullable()();

  TextColumn get source =>
      textEnum<TimeEntrySource>().withDefault(const Constant('timer'))();

  /// Na którym urządzeniu powstał wpis. Potrzebne, żeby wykryć
  /// stoper zapomniany na telefonie przy starcie nowego na PC.
  TextColumn get deviceId => text().withDefault(const Constant(''))();
}

/// Surowe próbki tego, co było na pierwszym planie.
///
/// To jest warstwa, która odpowiada na pytanie „gdzie faktycznie poszedł czas",
/// niezależnie od tego, czy pamiętałeś włączyć stoper. Zbierana automatycznie:
///  * Windows — odpytywanie aktywnego okna co kilka sekund,
///  * Android — `UsageStatsManager`, który oddaje przedziały wstecz,
///    więc nie trzeba trzymać usługi w tle.
///
/// Wiersze są scalane: ciągłe używanie tej samej aplikacji to jeden wiersz
/// z rosnącym [endedAt], a nie tysiąc próbek co 5 sekund.
@TableIndex(name: 'idx_usage_started', columns: {#startedAt})
@TableIndex(name: 'idx_usage_updated', columns: {#updatedAt})
class AppUsages extends Table with SyncedTable {
  TextColumn get deviceId => text()();

  TextColumn get platform =>
      textEnum<DevicePlatform>().withDefault(const Constant('unknown'))();

  /// `chrome.exe`, `steam.exe`, `com.google.android.youtube`.
  TextColumn get appId => text()();

  /// Nazwa czytelna dla człowieka („Google Chrome").
  TextColumn get appName => text().withDefault(const Constant(''))();

  /// Tytuł okna w chwili próbki. Na Androidzie prawie zawsze null.
  TextColumn get windowTitle => text().nullable()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  /// Denormalizowane, bo statystyki liczą po tym w każdej agregacji,
  /// a przeliczanie z [startedAt]/[endedAt] przy każdym zapytaniu
  /// zabijałoby wykresy miesięczne.
  IntColumn get durationSeconds => integer()();

  /// Wynik reguł w momencie zapisu.
  TextColumn get productivity =>
      textEnum<Productivity>().withDefault(const Constant('unknown'))();

  /// Która reguła zadecydowała. Null przy ręcznej zmianie przez użytkownika.
  TextColumn get ruleId => text().nullable()();

  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Czy człowiek potwierdził klasyfikację.
  ///
  /// Potwierdzone wiersze są odporne na późniejsze zmiany reguł —
  /// przeklasyfikowanie wstecz nie może kasować twoich własnych decyzji.
  BoolColumn get reviewed => boolean().withDefault(const Constant(false))();

  /// Ustawione, jeśli z tej aktywności zrobiono normalny wpis czasu.
  TextColumn get timeEntryId =>
      text().nullable().references(TimeEntries, #id)();

  /// Czy w tym czasie użytkownik był bezczynny (brak inputu).
  /// Odfiltrowuje godziny, gdy edytor stał otwarty, a ciebie nie było.
  BoolColumn get idle => boolean().withDefault(const Constant(false))();
}

/// Reguły przypisujące aktywność do klasy produktywności.
///
/// Rozstrzyga reguła o najwyższym [priority]; przy remisie ta bardziej
/// szczegółowa (dłuższy wzorzec). Reguły na tytule okna mają domyślnie
/// wyższy priorytet niż na nazwie aplikacji, bo to one pozwalają odróżnić
/// YouTube z kursem Fluttera od YouTube z kompilacją kotów.
@TableIndex(name: 'idx_rules_updated', columns: {#updatedAt})
class ActivityRules extends Table with SyncedTable {
  /// Etykieta dla człowieka („Gry na Steamie").
  TextColumn get label => text().withDefault(const Constant(''))();

  TextColumn get matchTarget =>
      textEnum<MatchTarget>().withDefault(const Constant('appId'))();

  TextColumn get matchType =>
      textEnum<MatchType>().withDefault(const Constant('contains'))();

  TextColumn get pattern => text()();

  /// Null = reguła działa na każdej platformie.
  TextColumn get platform => textEnum<DevicePlatform>().nullable()();

  TextColumn get productivity => textEnum<Productivity>()();

  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  IntColumn get priority => integer().withDefault(const Constant(0))();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  /// Reguła z zestawu wbudowanego. Można ją wyłączyć lub nadpisać,
  /// ale przy aktualizacji seeda wracają tylko wiersze wbudowane —
  /// twoje własne nigdy nie są ruszane.
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(false))();
}

/// Tablica pomysłów: co dodać, co zmienić, co jest zepsute.
///
/// Zapisywane w aplikacji, bo najlepsze pomysły przychodzą w trakcie
/// używania, a nie przy komputerze z otwartym edytorem. Całość eksportuje
/// się do Markdownu gotowego do wklejenia w rozmowę z asystentem —
/// patrz `IdeaExporter`.
@TableIndex(name: 'idx_ideas_updated', columns: {#updatedAt})
class Ideas extends Table with SyncedTable {
  TextColumn get title => text().withLength(min: 1, max: 300)();

  TextColumn get body => text().nullable()();

  TextColumn get kind =>
      textEnum<IdeaKind>().withDefault(const Constant('feature'))();

  TextColumn get status =>
      textEnum<IdeaStatus>().withDefault(const Constant('inbox'))();

  /// 1–5. Razem z [effort] daje prostą macierz „co robić najpierw".
  IntColumn get impact => integer().nullable()();
  IntColumn get effort => integer().nullable()();

  /// Tagi po przecinku. Świadomie bez osobnej tabeli — przy kilkuset
  /// wierszach relacja wiele-do-wielu to koszt bez zysku.
  TextColumn get tags => text().withDefault(const Constant(''))();

  /// Kiedy ostatnio trafiło do eksportu. Pozwala wygenerować paczkę
  /// „tylko nowe od ostatniego razu" zamiast wklejać wszystko od nowa.
  DateTimeColumn get exportedAt => dateTime().nullable()();

  /// Gdzie byłeś w aplikacji, gdy to zapisałeś — kontekst, który
  /// inaczej wyparowuje do następnego dnia.
  TextColumn get sourceScreen => text().nullable()();
}

/// Jeden wiersz na dzień: budżet czasu, intencja, wieczorna refleksja.
@TableIndex(name: 'idx_dayplans_updated', columns: {#updatedAt})
class DayPlans extends Table with SyncedTable {
  /// `YYYY-MM-DD`. Unikalne — jeden plan na dzień.
  TextColumn get date => text().unique()();

  /// Ile realnie masz dziś wolnego czasu, w minutach.
  ///
  /// Bez tej liczby nie da się powiedzieć „to się nie zmieści",
  /// a to jest jedyny mechanizm w całej aplikacji, który naprawdę
  /// ratuje przed zaplanowaniem dziesięciu godzin na pięć.
  IntColumn get availableMinutes => integer().nullable()();

  /// Jedno zdanie na rano: po co jest ten dzień.
  TextColumn get intention => text().nullable()();

  /// Wieczorne podsumowanie własnymi słowami — co poszło dobrze.
  ///
  /// Rozdzielone od [struggles], a nie wrzucone w jedno pole „notatki",
  /// bo puste pole zachęca do napisania niczego. Dwa konkretne pytania
  /// dostają odpowiedzi; jedno ogólne nie dostaje żadnej.
  TextColumn get wins => text().nullable()();

  /// Co nie wyszło i dlaczego.
  TextColumn get struggles => text().nullable()();

  /// Jedna rzecz do zmiany jutro. Celowo pojedyncza —
  /// lista pięciu postanowień to lista zero postanowień.
  TextColumn get changeTomorrow => text().nullable()();

  /// Ocena dnia 1–5, wystawiona ręcznie przy zamykaniu podsumowania.
  IntColumn get moodEnd => integer().nullable()();

  /// Kiedy domknięto podsumowanie. Null = dzień jeszcze nierozliczony,
  /// po tym pozna się, które dni pominąłeś.
  DateTimeColumn get reviewedAt => dateTime().nullable()();
}

/// Umiejętności, których postęp śledzisz: śpiew, gitara, pianino,
/// kalistenika, cardio — cokolwiek zdefiniujesz.
///
/// Świadomie oddzielone od [Categories]. Kategoria odpowiada na pytanie
/// „do której szuflady życia należy ten czas", umiejętność na „w czym się
/// rozwijam". Ćwiczenie gitary bywa jednocześnie kategorią *Nauka*
/// i umiejętnością *Gitara*, a mieszanie tych dwóch rzeczy w jedną tabelę
/// kończy się listą kategorii zaśmieconą pozycjami, które nie są kategoriami.
@TableIndex(name: 'idx_skills_updated', columns: {#updatedAt})
class Skills extends Table with SyncedTable {
  TextColumn get name => text().withLength(min: 1, max: 80)();

  /// Po co to robisz — jedno zdanie, widoczne na ekranie umiejętności.
  TextColumn get intent => text().nullable()();

  IntColumn get color => integer()();

  TextColumn get icon => text().nullable()();

  /// Od kiedy liczysz naukę. Null = od pierwszego wpisu.
  DateTimeColumn get startedAt => dateTime().nullable()();

  /// Docelowa liczba minut tygodniowo. Podstawa do oceny regularności,
  /// która przy nauce jest mocniejszym sygnałem niż suma godzin.
  IntColumn get weeklyTargetMinutes => integer().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Cele — krótkoterminowe i długoterminowe.
///
/// Sedno tej tabeli siedzi w [metric]: dla większości celów postęp liczy się
/// **sam**, z wpisów czasu, które aplikacja i tak zbiera. Cel wymagający
/// pamiętania o codziennym odhaczaniu umiera po dwóch tygodniach — a taki,
/// który wypełnia się w tle, przeżywa cały rok.
@TableIndex(name: 'idx_goals_skill', columns: {#skillId})
@TableIndex(name: 'idx_goals_status', columns: {#status})
@TableIndex(name: 'idx_goals_updated', columns: {#updatedAt})
class Goals extends Table with SyncedTable {
  /// Umiejętność, której cel dotyczy. Null dla celu ogólnego.
  TextColumn get skillId => text().nullable().references(Skills, #id)();

  /// Cel nadrzędny. Tak rozbija się „zagrać koncert" na kilka celów
  /// na najbliższe tygodnie — bez tego cel długoterminowy wisi
  /// jako pobożne życzenie, którego nie da się zacząć.
  TextColumn get parentGoalId => text().nullable()();

  TextColumn get title => text().withLength(min: 1, max: 300)();

  TextColumn get notes => text().nullable()();

  TextColumn get horizon =>
      textEnum<GoalHorizon>().withDefault(const Constant('short'))();

  TextColumn get metric =>
      textEnum<GoalMetric>().withDefault(const Constant('minutes'))();

  /// Do ilu dążymy: minut, sesji, dni serii albo sztuk.
  /// Dla [GoalMetric.milestone] zawsze 1.
  IntColumn get targetValue => integer().withDefault(const Constant(1))();

  /// Ręczny licznik dla metryk, których nie da się wyliczyć.
  IntColumn get manualProgress => integer().withDefault(const Constant(0))();

  /// Od kiedy liczymy postęp.
  ///
  /// Bez tego cel „przećwiczyć 50 godzin" byłby od razu spełniony przez
  /// historię sprzed jego założenia. Domyślnie moment utworzenia celu.
  DateTimeColumn get startsFrom => dateTime()();

  /// Termin. Null = bez terminu, co jest sensowne dla celów długoterminowych.
  DateTimeColumn get deadline => dateTime().nullable()();

  TextColumn get status =>
      textEnum<GoalStatus>().withDefault(const Constant('active'))();

  DateTimeColumn get achievedAt => dateTime().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Przypomnienia wyświetlane jako powiadomienia systemowe.
///
/// Wiersz w bazie jest źródłem prawdy, a zaplanowane powiadomienie tylko
/// jego odbiciem w systemie. Android kasuje wszystkie zaplanowane alarmy
/// przy restarcie telefonu i przy aktualizacji aplikacji — mając tabelę,
/// da się je po prostu przeplanować od nowa przy starcie.
@TableIndex(name: 'idx_reminders_updated', columns: {#updatedAt})
class Reminders extends Table with SyncedTable {
  TextColumn get title => text().withLength(min: 1, max: 200)();

  TextColumn get body => text().nullable()();

  /// Godzina i minuta w ciągu doby, jako minuty od północy.
  ///
  /// Nie `DateTime`, bo przypomnienie „o 19:00" ma być o 19:00 lokalnie
  /// każdego dnia — także po zmianie czasu i po zmianie strefy.
  IntColumn get minuteOfDay => integer()();

  /// Dni tygodnia wg [DateTime.monday]..[DateTime.sunday], po przecinku.
  /// Pusty ciąg = codziennie.
  TextColumn get weekdays => text().withDefault(const Constant(''))();

  /// Powiązanie kontekstowe — powiadomienie może otwierać wprost
  /// tę umiejętność albo ten cel.
  TextColumn get skillId => text().nullable().references(Skills, #id)();
  TextColumn get goalId => text().nullable().references(Goals, #id)();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  /// Kiedy ostatnio faktycznie wyświetlone — do diagnostyki, gdy telefon
  /// agresywnie usypia aplikację.
  DateTimeColumn get lastFiredAt => dateTime().nullable()();
}

/// Jeden wpis w dzienniku — jedna strona, jak w Obsidianie.
///
/// Treść to **Markdown w zwykłym polu tekstowym**, nie drzewo bloków.
/// Edytor blokowy to własny format danych i miesiąc pracy, a Markdown daje
/// nagłówki, listy i checkboxy, jest przeszukiwalny zapytaniem SQL
/// i wkleja się gdziekolwiek bez konwersji.
@TableIndex(name: 'idx_journal_skill', columns: {#skillId})
@TableIndex(name: 'idx_journal_date', columns: {#date})
@TableIndex(name: 'idx_journal_updated', columns: {#updatedAt})
class JournalEntries extends Table with SyncedTable {
  TextColumn get skillId => text().references(Skills, #id)();

  /// `YYYY-MM-DD` — dzień, którego wpis dotyczy.
  TextColumn get date => text()();

  TextColumn get title => text().withDefault(const Constant(''))();

  TextColumn get body => text().withDefault(const Constant(''))();

  /// Samoocena sesji 1–5.
  ///
  /// Subiektywna i o to chodzi: wykres tej jednej liczby w czasie wychwytuje
  /// „utknąłem" wcześniej, niż zauważysz to sam, a suma godzin tego nie pokaże.
  IntColumn get selfRating => integer().nullable()();

  /// Wpis oznaczający przełom („pierwszy raz wyszedł ten dźwięk").
  ///
  /// To do nich wraca się po roku — dlatego mają własną flagę
  /// i osobną oś czasu, zamiast ginąć wśród zwykłych sesji.
  BoolColumn get isMilestone => boolean().withDefault(const Constant(false))();

  /// Sesja pomiaru czasu, z której wpis powstał. Null dla notatki
  /// dopisanej bez ćwiczenia.
  TextColumn get timeEntryId =>
      text().nullable().references(TimeEntries, #id)();
}

/// Plik dołączony do wpisu.
///
/// Pliki są **kopiowane do katalogu aplikacji**, a nie tylko wskazywane
/// w galerii. Referencja byłaby tańsza, ale przy dzienniku prowadzonym
/// latami skasowanie zdjęcia w galerii to kwestia „kiedy", nie „czy" —
/// a wtedy wpis zostaje z martwym odnośnikiem.
@TableIndex(name: 'idx_attachments_entry', columns: {#entryId})
@TableIndex(name: 'idx_attachments_updated', columns: {#updatedAt})
class Attachments extends Table with SyncedTable {
  TextColumn get entryId => text().references(JournalEntries, #id)();

  TextColumn get kind => textEnum<AttachmentKind>()();

  /// Nazwa pliku wewnątrz katalogu mediów aplikacji, bez ścieżki.
  ///
  /// Sama nazwa, bo ścieżka bezwzględna zmienia się między urządzeniami
  /// i po aktualizacji systemu — zapisana w bazie zepsułaby się przy
  /// pierwszej synchronizacji na drugie urządzenie.
  TextColumn get fileName => text()();

  /// Nazwa nadana przez użytkownika albo oryginalna nazwa pliku.
  TextColumn get label => text().withDefault(const Constant(''))();

  TextColumn get mimeType => text().withDefault(const Constant(''))();

  IntColumn get bytes => integer().withDefault(const Constant(0))();

  /// Długość nagrania w milisekundach — dla audio i wideo.
  IntColumn get durationMs => integer().nullable()();

  /// Suma kontrolna zawartości. Służy do deduplikacji przy imporcie
  /// tego samego pliku dwa razy i do sprawdzenia, czy plik pobrany
  /// z synchronizacji dojechał w całości.
  TextColumn get sha256 => text().withDefault(const Constant(''))();

  TextColumn get syncState => textEnum<AttachmentSyncState>()
      .withDefault(const Constant('localOnly'))();

  /// Ścieżka w magazynie zdalnym. Null, dopóki plik nie został wysłany.
  TextColumn get remotePath => text().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Znane urządzenia. Potrzebne dla czytelnych komunikatów
/// („stoper chodzi od 3 h na *Pixelu*").
class Devices extends Table with SyncedTable {
  TextColumn get name => text()();
  TextColumn get platform => textEnum<DevicePlatform>()();
  DateTimeColumn get lastSeenAt => dateTime()();
}

/// Ustawienia i stan synchronizacji — klucz/wartość.
///
/// **Nie jest synchronizowana.** Trzyma rzeczy z definicji lokalne:
/// `device_id`, `last_synced_at`, token sesji. Wysłanie `last_synced_at`
/// na serwer i odebranie go na drugim urządzeniu zapętliłoby sync.
class LocalSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

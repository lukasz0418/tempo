# Tempo

Prywatna aplikacja do zarządzania czasem i zadaniami — Android i Windows,
jeden kod źródłowy.

Cztery rzeczy odróżniają ją od zwykłej listy zadań ze stoperem:

1. **Uczy się, jak szacujesz.** Każde zadanie ma estymatę w postaci zakresu.
   Po kilkudziesięciu zamkniętych zadaniach aplikacja liczy twój
   *współczynnik optymizmu* i koryguje o niego kolejne podpowiedzi.
2. **Wie, gdzie realnie poszedł czas.** Automatycznie odczytuje, co było na
   pierwszym planie, i dzieli dobę na cztery klasy: produktywny / neutralny /
   odpoczynek / rozpraszacz. Niezależnie od tego, czy pamiętałeś włączyć stoper.
3. **Rozlicza dzień.** Wieczorne podsumowanie wypisuje konkretnie, co poszło
   dobrze, a co nie — z liczb, nie z samopoczucia.
4. **Prowadzi dziennik rozwoju.** Umiejętności (dowolne — śpiew, gitara,
   kalistenika) z wpisami po każdej sesji: notatka w Markdownie, nagranie
   głosu, zdjęcia. Do tego cele, których postęp liczy się sam.

## Dziennik umiejętności

Umiejętności definiujesz sam. Sesja ćwiczeń to zwykły wpis czasu z przypisaną
umiejętnością, więc godziny liczą się z tego samego pomiaru, co reszta
aplikacji — bez osobnego stopera.

Postęp pokazywany jest **trzema liczbami obok siebie**, bo każda z osobna
kłamie: same godziny nie mówią nic o jakości pracy, sama regularność nie mówi
o jej głębokości, a sama samoocena bywa nastrojem.

| Liczba | Skąd |
|---|---|
| Łączny czas | suma wpisów czasu z tą umiejętnością |
| Regularność | ile z ostatnich 30 dni miało sesję albo wpis |
| Trend samooceny | ocena 1–5 wystawiana po sesji, na wykresie w czasie |

### Media — kopiowane, nie wskazywane

Pliki lądują w katalogu aplikacji (`Android/data/com.franek.tempo/files/media`),
a nie jako odnośnik do galerii. Referencja byłaby tańsza, ale przy dzienniku
prowadzonym latami skasowanie zdjęcia w galerii to kwestia „kiedy", nie „czy" —
a wtedy wpis sprzed roku zostaje z martwym odnośnikiem.

- **nagrania głosowe** — AAC 64 kbps mono, ~1,5 MB na trzy minuty. Przy nauce
  śpiewu czy gry to jedyny artefakt, który po pół roku pokaże różnicę
- **zdjęcia** — zmniejszane do 2048 px przy imporcie, ~500 KB zamiast 4 MB
- **wideo** — kopiowane bez przekodowywania: transkodowanie na telefonie trwa
  minutami i psuje nagranie, które właśnie chciałeś zachować

Nazwa pliku pochodzi z sumy kontrolnej zawartości, więc to samo zdjęcie
dołączone do dwóch wpisów nie zajmuje miejsca dwa razy.

> Odinstalowanie aplikacji kasuje ten katalog. Przed synchronizacją mediów
> w chmurze chroni przed tym tylko ręczna kopia.

### Cele

Krótkoterminowe i długoterminowe, przy czym długoterminowy da się rozbić
na krótkoterminowe (`parent_goal_id`). **Cztery z sześciu metryk liczą się
same** z danych, które aplikacja i tak zbiera:

| Metryka | Liczona |
|---|---|
| Przećwiczony czas | automatycznie |
| Liczba sesji | automatycznie |
| Dni z rzędu | automatycznie |
| Dni ćwiczeń | automatycznie |
| Osiągnięcie | ręcznie, zero-jedynkowo |
| Własny licznik | ręcznie |

To nie jest wygoda, tylko warunek działania: cel wymagający codziennego
odhaczania umiera po dwóch tygodniach, a taki, który wypełnia się w tle,
przeżywa cały rok. Postęp liczony jest od **założenia celu**, nie od zawsze —
inaczej „przećwiczyć 50 godzin" byłoby spełnione w chwili utworzenia.

### Przypomnienia

Powiadomienia systemowe o stałej porze, opcjonalnie w wybrane dni tygodnia.
Używają alarmów nieprecyzyjnych, żeby nie wymagać uprawnienia
`SCHEDULE_EXACT_ALARM` — przy przypomnieniu o ćwiczeniu kilka minut różnicy
nie ma znaczenia.

Android kasuje wszystkie zaplanowane alarmy przy restarcie telefonu i przy
aktualizacji aplikacji, więc źródłem prawdy jest tabela `reminders`, a alarmy
odtwarzane są przy każdym starcie.

## Uruchomienie

Środowisko (Flutter, Git, cache) leży na `D:\dev`, poza dyskiem systemowym:

```powershell
. D:\dev\env.ps1     # ustawia PATH, PUB_CACHE, GRADLE_USER_HOME, ANDROID_HOME
flutter run -d windows
```

Android — z podłączonym telefonem albo emulatorem:

```powershell
flutter devices
flutter run -d <id-urządzenia>
```

Po zmianie czegokolwiek w `lib/core/db/tables.dart` trzeba przegenerować
warstwę drifta:

```powershell
dart run build_runner build
```

## Struktura

```
lib/
  app/            szkielet aplikacji, providery Riverpod, motyw i paleta wykresów
  core/
    db/           schemat drifta, DAO, dane startowe
      tables.dart      ← schemat; najczęściej odwiedzany plik w projekcie
      seed.dart        ← kategorie i wbudowane reguły klasyfikacji
    tracking/     odczyt aktywności (Windows FFI, Android UsageStats) i silnik reguł
    estimation/   współczynnik optymizmu i podpowiedzi estymat
    review/       automatyczne wnioski do podsumowania dnia
    recurrence/   uproszczony RRULE dla zadań cyklicznych
    ideas/        eksport tablicy pomysłów do Markdownu
    update/       aktualizacje OTA na Androidzie
  features/       ekrany: today, tasks, insights, review, ideas, settings
docs/             schemat backendu i opis aktualizacji
tools/release.ps1 skrypt wydania na telefon
```

## Warstwa danych

Lokalny SQLite jest **źródłem prawdy**, backend to tylko kopia. Wszystkie
zapisy idą lokalnie i natychmiast; synchronizacja leci w tle. Bez tego
uruchomienie stopera wymagałoby sieci, a to zabija taką aplikację —
najczęściej chcesz coś zapisać właśnie tam, gdzie nie ma zasięgu.

Schemat jest przygotowany pod synchronizację last-write-wins:

| Kolumna      | Rola |
|--------------|------|
| `id`         | UUID **generowany na kliencie** — rekord powstaje offline, bez czekania na serwer |
| `updated_at` | rozstrzyga konflikty: wygrywa nowszy zapis |
| `deleted`    | tombstone; bez niego usunięcie z telefonu nie dotarłoby na PC |
| `dirty`      | „zmienione lokalnie, niewysłane" — istnieje wyłącznie lokalnie |

Świadomie **nie ma tu CRDT ani historii operacji**. Jeden użytkownik edytuje
z jednego urządzenia naraz; jedyny realny konflikt to zmiana tego samego
zadania na telefonie i na PC w ciągu tej samej minuty. Last-write-wins
wystarcza i oszczędza tygodnie pracy.

Schemat Postgresa wraz z politykami RLS: [`docs/supabase_schema.sql`](docs/supabase_schema.sql).
Sama warstwa sieciowa nie jest jeszcze podłączona — patrz „Co dalej".

## Klasyfikacja czasu

| Platforma | Skąd dane | Uprawnienia |
|---|---|---|
| Windows | aktywne okno co 5 s przez `dart:ffi`, plus wykrywanie bezczynności | brak |
| Android | `UsageStatsManager`, import wsteczny przy każdym otwarciu apki | „Dostęp do danych o użyciu", nadawany ręcznie w ustawieniach |

Rozstrzyga reguła o najwyższym priorytecie; przy remisie wygrywa bardziej
szczegółowy wzorzec. Reguły na **tytule okna** biją reguły na nazwie
aplikacji — i to jest sedno całego mechanizmu: ta sama przeglądarka jest raz
pracą, a raz rozpraszaczem, a odróżnia je wyłącznie tytuł strony.

Na Androidzie tytułów nie ma — system ich nie udostępnia bez usług
dostępności, a te czytają zawartość każdego ekranu. Cena nieproporcjonalna
do zysku, więc na telefonie klasyfikacja działa na poziomie całej aplikacji.

Blok zaklasyfikowany ręcznie dostaje flagę `reviewed` i jest odporny na
późniejsze przeliczenia — automat nie może nadpisać twojej decyzji.

## Aktualizacje na telefonie

Programujesz na PC, telefon aktualizuje się sam:
[`docs/UPDATES.md`](docs/UPDATES.md).

```powershell
.\tools\release.ps1 -Notes "Co nowego" -BaseUrl "https://..." -Publish
```

## Testy

```powershell
flutter test
```

Testy pokrywają logikę, w której faktycznie da się pomylić: silnik reguł,
liczenie współczynnika optymizmu, arytmetykę powtarzania zadań (przełom
miesiąca, 31 stycznia) i progi generujące wnioski o dniu. UI nie jest
testowany — przy prywatnej aplikacji koszt utrzymania testów widoków
przewyższa zysk.

## Co dalej

Kolejność wynika z tego, co realnie blokuje co innego:

1. **Używać przez 2–3 tygodnie na jednym urządzeniu.** Połowa pomysłów na
   funkcje zmieni się po zderzeniu z rzeczywistością — lepiej, żeby stało się
   to przed napisaniem synchronizacji.
2. **Podłączyć Supabase.** Schemat i polityki są gotowe; brakuje warstwy
   sieciowej: push wierszy z `dirty`, pull po `updated_at`, potem
   `TimeEntryDao.reconcileRunning()`.
3. **Tryb „co teraz?"** — jeden przycisk biorący pod uwagę wolny czas, porę
   dnia i energię, proponujący jedno zadanie.
4. **Powiadomienie o zapomnianym stoperze** — dziś ostrzeżenie widać dopiero
   po wejściu do aplikacji.

Pomysły zbierane w samej aplikacji (zakładka *Pomysły*) eksportują się do
Markdownu razem z opisem projektu w nagłówku — gotowe do wklejenia w rozmowę.

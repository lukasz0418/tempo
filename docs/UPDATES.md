# Zdalne aktualizacje aplikacji na telefonie

Scenariusz: jesteś poza domem, programujesz na PC przez zdalny pulpit,
a aplikacja na telefonie ma się aktualizować bez podpinania kabla.

## Jak to działa

```
PC                              hosting                     telefon
─────────────────────────       ──────────────────          ──────────────────
tools\release.ps1
  ├─ podnosi build number
  ├─ analyze + testy       ──▶  (przerywa przy błędzie)
  ├─ buduje podpisany APK
  ├─ liczy SHA-256
  └─ generuje update.json  ──▶  update.json  ◀── pobiera i porównuje
                                tempo-N.apk  ◀── pobiera, sprawdza sumę
                                                 └─ oddaje instalatorowi
```

Telefon porównuje **wyłącznie `versionCode`** (liczba po `+` w `pubspec.yaml`).
Nazwa wersji jest dla człowieka i nie nadaje się do porównań — `1.0.10`
jest tekstowo mniejsze niż `1.0.9`.

## Konfiguracja jednorazowa

### 1. Klucz podpisujący

Już wygenerowany: `D:\dev\keys\tempo-release.jks`, hasło w
`D:\dev\keys\HASLO-KEYSTORE.txt`, konfiguracja w `android/key.properties`
(poza repozytorium).

> **Zrób kopię zapasową tego pliku.** Android pozwala zaktualizować aplikację
> tylko wtedy, gdy nowy APK jest podpisany **dokładnie tym samym kluczem**.
> Utrata klucza oznacza konieczność odinstalowania aplikacji z telefonu —
> razem ze wszystkimi danymi.

### 2. Gdzie hostować

Aplikacja nie wie, co serwuje pliki. Wymaga tylko **HTTPS** — po HTTP
ktokolwiek w tej samej sieci mógłby podstawić własny plik APK, a ty
zobaczyłbyś zwykły ekran instalacji.

| Opcja | Kiedy pasuje |
|---|---|
| **GitHub Releases** | domyślna: darmowa, stabilny adres, działa z każdej sieci |
| Własny VPS / hosting statyczny | masz już serwer |
| Cloudflare Tunnel / Tailscale do PC | nie chcesz nic wystawiać publicznie |

Dla GitHub Releases adres manifestu wygląda tak:

```
https://github.com/UŻYTKOWNIK/REPO/releases/latest/download/update.json
```

`latest/download/` zawsze wskazuje na najnowsze wydanie, więc adres wpisujesz
w telefon raz i nigdy go nie zmieniasz.

### 3. Ustawienie w telefonie

*Ustawienia → Aktualizacje* → wklej adres manifestu → **Zapisz adres**.

Przy pierwszej instalacji Android poprosi o zgodę
„Instalowanie nieznanych aplikacji" dla Tempo. Bez niej instalator startuje
i od razu odbija się od systemu, co wygląda jak zawieszenie — dlatego
aplikacja sprawdza tę zgodę zawczasu i sama otwiera właściwy ekran ustawień.

## Wydanie nowej wersji

```powershell
. D:\dev\env.ps1
cd D:\test
.\tools\release.ps1 -Notes "Podsumowanie dnia" -BaseUrl "https://github.com/USER/REPO/releases/latest/download" -Publish
```

Skrypt **przerywa przy błędzie analizy lub nieprzechodzących testach**. To
celowe: wydania na telefon nie da się szybko cofnąć, więc lepiej złapać
problem na PC.

Bez `-Publish` pliki lądują w `dist\` i wgrywasz je ręcznie.

## Format manifestu

```json
{
  "versionCode": 12,
  "versionName": "1.0.12",
  "apkUrl": "https://github.com/USER/REPO/releases/latest/download/tempo-12.apk",
  "notes": "Podsumowanie dnia",
  "sha256": "a1b2c3…",
  "minSupportedCode": null
}
```

`sha256` chroni przed **uszkodzonym pobraniem**, nie przed atakiem — manifest
i plik pochodzą z tego samego miejsca, więc kto podmieni jedno, podmieni
i drugie. Przed podmianą chroni wyłącznie HTTPS.

`minSupportedCode` ustaw, gdy aktualizacja nie może przejść automatycznie
(np. zmieniłeś klucz podpisujący). Starsze wersje pokażą wtedy komunikat
o konieczności ręcznej instalacji, zamiast w kółko odbijać się od instalatora.

## Ograniczenia

Ta ścieżka wymienia całą aplikację, więc obsłuży **każdą** zmianę — również
w kodzie Kotlina i w zależnościach. Jest za to głośna: przy każdej
aktualizacji zobaczysz systemowy dialog instalatora. Cichej instalacji nie da
się tu zrobić i nie powinno się dać.

Jeśli zaczną cię męczyć te dialogi przy drobnych poprawkach, alternatywą jest
**Shorebird** (code push dla Fluttera) — podmienia sam kod Dart bez
reinstalacji, w kilka sekund. Nie przeniesie jednak zmian w kodzie natywnym
ani nowych paczek, więc nie zastępuje tego mechanizmu, tylko go uzupełnia:
Shorebird do poprawek w Darcie, APK do wszystkiego innego.

## Gdy coś nie działa

| Objaw | Przyczyna |
|---|---|
| „Adres manifestu musi zaczynać się od https://" | wpisany `http://` lub literówka |
| Instalator nie startuje | brak zgody „Instalowanie nieznanych aplikacji" |
| „Aplikacja nie została zainstalowana" | APK podpisany innym kluczem — sprawdź, czy `android/key.properties` istniało w trakcie builda |
| Telefon nie widzi nowej wersji | `versionCode` nie został podniesiony (użyto `-SkipBump`?) |
| Pobieranie kończy się błędem sumy kontrolnej | plik na hostingu nie zgadza się z manifestem — wgraj oba z tego samego wydania |

<#
.SYNOPSIS
    Buduje wydanie Tempo na Androida i przygotowuje manifest aktualizacji.

.DESCRIPTION
    Domyka pętlę zdalnej aktualizacji: podnosi numer builda, buduje podpisany
    APK, liczy sumę kontrolną i generuje `update.json`, po który sięga
    aplikacja na telefonie.

    Numer builda z `pubspec.yaml` (część po znaku `+`) staje się androidowym
    `versionCode` i jest **jedyną** liczbą, po której telefon porównuje wersje.
    Dlatego każde wydanie musi go podnieść — inaczej telefon uzna, że nic
    się nie zmieniło.

.PARAMETER Notes
    Krótki opis zmian, widoczny w aplikacji przed instalacją.

.PARAMETER BaseUrl
    Adres, pod którym wyląduje plik APK. Musi być https — aplikacja
    odrzuca każdy inny schemat.

.PARAMETER Publish
    Wypycha wydanie na GitHub Releases (wymaga zalogowanego `gh`).

.PARAMETER Abi
    Architektura, pod którą powstaje wydawany plik. Domyślnie `arm64-v8a` —
    ma ją każdy telefon z ostatnich lat. `armeabi-v7a` tylko dla naprawdę
    starego sprzętu, `x86_64` dla emulatora.

.EXAMPLE
    .\tools\release.ps1 -Notes "Podsumowanie dnia" -Publish
#>
[CmdletBinding()]
param(
    [string]$Notes = '',
    [string]$BaseUrl = '',
    [ValidateSet('arm64-v8a', 'armeabi-v7a', 'x86_64')]
    [string]$Abi = 'arm64-v8a',
    [switch]$Publish,
    [switch]$SkipBump
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

# --- środowisko -------------------------------------------------------------
$envScript = 'D:\dev\env.ps1'
if (Test-Path $envScript) { . $envScript }

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw "Nie znaleziono `flutter` w PATH. Uruchom najpierw: . D:\dev\env.ps1"
}

# --- podniesienie numeru builda --------------------------------------------
$pubspecPath = Join-Path $repo 'pubspec.yaml'
$pubspec = Get-Content $pubspecPath -Raw -Encoding UTF8

if ($pubspec -notmatch '(?m)^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)\s*$') {
    throw "Nie udało się odczytać wersji z pubspec.yaml (oczekiwano formatu 'version: x.y.z+n')."
}
$versionName = $Matches[1]
$buildNumber = [int]$Matches[2]

if (-not $SkipBump) {
    $buildNumber++
    # Nazwa wersji idzie za numerem builda, żeby człowiek też widział postęp.
    $parts = $versionName.Split('.')
    $versionName = "$($parts[0]).$($parts[1]).$buildNumber"

    $pubspec = $pubspec -replace '(?m)^version:\s*.+$', "version: $versionName+$buildNumber"
    [IO.File]::WriteAllText($pubspecPath, $pubspec, (New-Object Text.UTF8Encoding $false))
    Write-Host "Wersja podniesiona do $versionName+$buildNumber" -ForegroundColor Cyan
} else {
    Write-Host "Pominięto podniesienie wersji: $versionName+$buildNumber" -ForegroundColor Yellow
}

# --- kontrola jakości przed wydaniem ---------------------------------------
# Wydanie, które nie przechodzi analizy i testów, nie ma prawa trafić
# na telefon — na telefonie nie ma jak go szybko cofnąć.
Write-Host "`n== Analiza ==" -ForegroundColor Cyan
flutter analyze
if ($LASTEXITCODE -ne 0) { throw 'flutter analyze zgłosił błędy — przerywam.' }

Write-Host "`n== Testy ==" -ForegroundColor Cyan
flutter test
if ($LASTEXITCODE -ne 0) { throw 'Testy nie przeszły — przerywam.' }

# --- build ------------------------------------------------------------------
if (-not (Test-Path (Join-Path $repo 'android\key.properties'))) {
    Write-Warning 'Brak android/key.properties — APK zostanie podpisany kluczem debugowym, a aktualizacje OTA nie zadziałają.'
}

Write-Host "`n== Build APK ==" -ForegroundColor Cyan
# Budujemy osobny plik na architekturę zamiast jednego uniwersalnego.
#
# APK uniwersalny waży ~58 MB, bo niesie biblioteki natywne na wszystkie
# architektury naraz. Wersja pod samo arm64 to ~23 MB — a przy aktualizacjach
# ściąganych przez dane komórkowe różnica 35 MB na każde wydanie jest realna.
#
# `force-version-code-ignoring-abi` jest tu OBOWIĄZKOWE: bez tej flagi Flutter
# dolicza do versionCode 1000 × indeks architektury, więc telefon zgłaszałby
# build 1002 zamiast 2 i uznawałby, że jest nowszy niż manifest — aktualizacje
# przestałyby się w ogóle pokazywać.
flutter build apk --release --split-per-abi -Pforce-version-code-ignoring-abi=true
if ($LASTEXITCODE -ne 0) { throw 'Build APK nie powiódł się.' }

$apkSource = Join-Path $repo "build\app\outputs\flutter-apk\app-$Abi-release.apk"
if (-not (Test-Path $apkSource)) {
    $available = (Get-ChildItem (Join-Path $repo 'build\app\outputs\flutter-apk') -Filter '*.apk' |
        ForEach-Object { $_.Name }) -join ', '
    throw "Nie znaleziono APK dla architektury '$Abi'. Dostępne: $available"
}

# --- paczka wydania ---------------------------------------------------------
$dist = Join-Path $repo 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null

$apkName = "tempo-$buildNumber-$Abi.apk"
$apkTarget = Join-Path $dist $apkName
Copy-Item $apkSource $apkTarget -Force

$hash = (Get-FileHash $apkTarget -Algorithm SHA256).Hash.ToLower()
$sizeMb = [math]::Round((Get-Item $apkTarget).Length / 1MB, 1)

if (-not $BaseUrl) {
    $BaseUrl = "https://github.com/USER/REPO/releases/latest/download"
    Write-Warning "Nie podano -BaseUrl. W manifeście wstawiono placeholder: $BaseUrl"
}

$manifest = [ordered]@{
    versionCode = $buildNumber
    versionName = $versionName
    apkUrl      = "$($BaseUrl.TrimEnd('/'))/$apkName"
    notes       = $Notes
    sha256      = $hash
}

$manifestPath = Join-Path $dist 'update.json'
$manifest | ConvertTo-Json -Depth 3 | Set-Content $manifestPath -Encoding utf8

Write-Host "`n== Gotowe ==" -ForegroundColor Green
Write-Host "APK:      $apkTarget ($sizeMb MB, $Abi)"
Write-Host "Manifest: $manifestPath"
Write-Host "SHA-256:  $hash"

# Kontrola, że versionCode w gotowym pliku zgadza się z manifestem.
# Rozjazd tutaj jest cichy i objawia się dopiero tym, że telefon
# nigdy nie widzi aktualizacji — lepiej złapać go na PC.
$aapt = Get-ChildItem "$env:LOCALAPPDATA\Android\Sdk\build-tools" -Filter 'aapt2.exe' -Recurse -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending | Select-Object -First 1
if ($aapt) {
    $badging = & $aapt.FullName dump badging $apkTarget 2>$null | Select-String -Pattern "versionCode='(\d+)'"
    if ($badging -and $badging.Matches[0].Groups[1].Value -ne "$buildNumber") {
        throw "versionCode w APK ($($badging.Matches[0].Groups[1].Value)) nie zgadza się z manifestem ($buildNumber). Telefon nie zobaczyłby tej aktualizacji."
    }
    Write-Host "versionCode w APK zgodny z manifestem: $buildNumber" -ForegroundColor Green
}

# --- publikacja -------------------------------------------------------------
if ($Publish) {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw "Brak GitHub CLI (`gh`). Zainstaluj go albo wgraj pliki z katalogu dist\ ręcznie."
    }

    $tag = "v$versionName"
    Write-Host "`n== Publikacja $tag ==" -ForegroundColor Cyan

    # `--clobber` pozwala nadpisać pliki, jeśli wydanie o tym tagu już istnieje —
    # bez tego ponowna próba po nieudanym wysłaniu kończy się błędem.
    gh release create $tag $apkTarget $manifestPath --title $tag --notes $Notes 2>$null
    if ($LASTEXITCODE -ne 0) {
        gh release upload $tag $apkTarget $manifestPath --clobber
        if ($LASTEXITCODE -ne 0) { throw 'Publikacja na GitHub nie powiodła się.' }
    }

    Write-Host "Opublikowano. Telefon zobaczy aktualizację przy najbliższym sprawdzeniu." -ForegroundColor Green
}

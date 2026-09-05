import 'package:flutter/material.dart';

import '../core/db/enums.dart';

/// Kolory wykresów i tokeny tekstu.
///
/// Podział czasu na cztery klasy to **skala uporządkowana** (dobrze ↔ źle),
/// nie zbiór niezależnych kategorii — dlatego zamiast palety kategorycznej
/// używamy pary rozbieżnej: niebieski jako biegun dodatni, czerwony jako
/// ujemny, szary jako środek. Odpoczynek dostaje jaśniejszy krok tej samej
/// niebieskiej rampy, bo to wciąż czas wydany świadomie — po prostu
/// mniej „naładowany" niż praca.
///
/// Wszystkie wartości pochodzą ze zwalidowanej palety referencyjnej
/// w ich udokumentowanych rolach (para rozbieżna, szary środek, kroki rampy
/// sekwencyjnej). Nie mieszamy własnych odcieni — a jeśli kiedyś zajdzie
/// taka potrzeba, paletę trzeba przepuścić przez walidator CVD, zamiast
/// oceniać ją okiem.
abstract final class VizColors {
  // --- powierzchnie i tusz ---
  static const surfaceLight = Color(0xFFFCFCFB);
  static const surfaceDark = Color(0xFF1A1A19);
  static const inkPrimaryLight = Color(0xFF0B0B0B);
  static const inkPrimaryDark = Color(0xFFFFFFFF);
  static const inkSecondaryLight = Color(0xFF52514E);
  static const inkSecondaryDark = Color(0xFFC3C2B7);
  static const inkMuted = Color(0xFF898781);
  static const gridLight = Color(0xFFE1E0D9);
  static const gridDark = Color(0xFF2C2C2A);

  // --- klasy produktywności ---
  static const _productiveLight = Color(0xFF2A78D6); // niebieski, krok 450
  static const _productiveDark = Color(0xFF3987E5);
  static const _leisureLight = Color(0xFF86B6EF); // ta sama rampa, krok 250
  static const _leisureDark = Color(0xFF184F95); // krok 600 pod ciemne tło
  static const _neutralLight = Color(0xFFC3C2B7); // szary środek
  static const _neutralDark = Color(0xFF383835);
  static const _distractionLight = Color(0xFFD03B3B); // czerwony biegun
  static const _distractionDark = Color(0xFFD03B3B);
  static const _unknownLight = Color(0xFFE1E0D9);
  static const _unknownDark = Color(0xFF2C2C2A);

  static Color forProductivity(Productivity p, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (p) {
      Productivity.productive => dark ? _productiveDark : _productiveLight,
      Productivity.leisure => dark ? _leisureDark : _leisureLight,
      Productivity.neutral => dark ? _neutralDark : _neutralLight,
      Productivity.distraction => dark ? _distractionDark : _distractionLight,
      Productivity.unknown => dark ? _unknownDark : _unknownLight,
    };
  }

  /// Rampa sekwencyjna (jeden odcień, jaśniejszy → ciemniejszy).
  ///
  /// Do mapy godzin i rankingów wielkości. Jasny koniec startuje od kroku 250,
  /// bo niższe kroki znikają w jasnym tle i przestają cokolwiek znaczyć.
  static const sequentialLight = [
    Color(0xFF86B6EF), // 250
    Color(0xFF5598E7), // 350
    Color(0xFF2A78D6), // 450
    Color(0xFF256ABF), // 500
    Color(0xFF184F95), // 600
    Color(0xFF0D366B), // 700
  ];

  static const sequentialDark = [
    Color(0xFF184F95), // 600
    Color(0xFF256ABF), // 500
    Color(0xFF2A78D6), // 450
    Color(0xFF3987E5), // 400
    Color(0xFF6DA7EC), // 300
    Color(0xFF9EC5F4), // 200
  ];

  /// Krok rampy dla wartości znormalizowanej 0..1.
  static Color sequential(double t, Brightness brightness) {
    final ramp =
        brightness == Brightness.dark ? sequentialDark : sequentialLight;
    if (t <= 0) return ramp.first;
    if (t >= 1) return ramp.last;
    final index = (t * (ramp.length - 1)).round();
    return ramp[index];
  }

  /// Tło komórki mapy, gdy wartość jest zerowa — ma zniknąć,
  /// a nie udawać najniższy krok skali.
  static Color emptyCell(Brightness brightness) =>
      brightness == Brightness.dark ? gridDark : gridLight;

  static Color ink(Brightness b) =>
      b == Brightness.dark ? inkPrimaryDark : inkPrimaryLight;

  static Color inkSecondary(Brightness b) =>
      b == Brightness.dark ? inkSecondaryDark : inkSecondaryLight;

  static Color grid(Brightness b) =>
      b == Brightness.dark ? gridDark : gridLight;

  static Color surface(Brightness b) =>
      b == Brightness.dark ? surfaceDark : surfaceLight;
}

/// Nazwy klas produktywności widoczne dla użytkownika.
String productivityLabel(Productivity p) => switch (p) {
      Productivity.productive => 'Produktywny',
      Productivity.neutral => 'Neutralny',
      Productivity.leisure => 'Odpoczynek',
      Productivity.distraction => 'Rozpraszacz',
      Productivity.unknown => 'Bez klasyfikacji',
    };

/// Kolejność wyświetlania: od „dobrze wydanego" do „straconego".
///
/// Stała, niezależna od tego, ile czasu wpadło w którą klasę — kolor
/// i pozycja mają należeć do znaczenia, nie do wielkości słupka.
const productivityOrder = [
  Productivity.productive,
  Productivity.leisure,
  Productivity.neutral,
  Productivity.distraction,
  Productivity.unknown,
];

ThemeData buildTheme(Brightness brightness) {
  final base = ThemeData(
    brightness: brightness,
    colorSchemeSeed: VizColors._productiveLight,
    useMaterial3: true,
  );

  return base.copyWith(
    scaffoldBackgroundColor:
        brightness == Brightness.dark ? const Color(0xFF0D0D0D) : const Color(0xFFF9F9F7),
    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      color: VizColors.surface(brightness),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: VizColors.grid(brightness)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: VizColors.grid(brightness),
      thickness: 1,
      space: 1,
    ),
  );
}

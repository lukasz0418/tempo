import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/db/enums.dart';
import '../../core/util/dates.dart';

/// Poziomy słupek skumulowany: podział doby na klasy produktywności.
///
/// Forma wybrana pod zadanie „część do całości". Dwie rzeczy są tu
/// wymagane specyfikacją i celowo nie są kosmetyką:
///  * **2 px przerwy w kolorze tła** między segmentami — to biel rozdziela
///    sąsiednie bloki, nie obwódka. Obwódka dokłada tusz, który nie jest daną.
///  * **legenda zawsze obecna** przy czterech seriach, plus etykiety wprost
///    na segmentach tam, gdzie się mieszczą. Tożsamość nigdy nie może
///    zależeć wyłącznie od koloru.
class ProductivityStackedBar extends StatelessWidget {
  const ProductivityStackedBar({
    required this.split,
    this.height = 28,
    super.key,
  });

  final Map<Productivity, Duration> split;
  final double height;

  static const _gap = 2.0;
  static const _radius = 4.0;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final segments = productivityOrder
        .map((p) => (p: p, d: split[p] ?? Duration.zero))
        .where((s) => s.d.inSeconds > 0)
        .toList();

    if (segments.isEmpty) {
      return _EmptyBar(height: height, brightness: brightness);
    }

    final total = segments.fold<int>(0, (sum, s) => sum + s.d.inSeconds);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gaps = _gap * (segments.length - 1);
              final usable = (constraints.maxWidth - gaps).clamp(0.0, double.infinity);

              return Row(
                children: [
                  for (var i = 0; i < segments.length; i++) ...[
                    if (i > 0) const SizedBox(width: _gap),
                    _Segment(
                      width: usable * (segments[i].d.inSeconds / total),
                      color: VizColors.forProductivity(segments[i].p, brightness),
                      // Zaokrąglone tylko skrajne końce — wnętrze stosu
                      // ma pozostać ciągłe.
                      isFirst: i == 0,
                      isLast: i == segments.length - 1,
                      label: formatDuration(segments[i].d),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _Legend(segments: segments, brightness: brightness),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.width,
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.label,
  });

  final double width;
  final Color color;
  final bool isFirst;
  final bool isLast;
  final String label;

  /// Poniżej tej szerokości etykieta nie zmieści się z zapasem po bokach.
  /// Wtedy jej nie ma — przycięty tekst jest gorszy niż jego brak,
  /// a wartość i tak stoi w legendzie.
  static const _minWidthForLabel = 56.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(isFirst ? ProductivityStackedBar._radius : 0),
            right: Radius.circular(isLast ? ProductivityStackedBar._radius : 0),
          ),
        ),
        child: width < _minWidthForLabel
            ? null
            : Center(
                child: Text(
                  label,
                  style: TextStyle(
                    // Etykieta w środku wypełnienia to jedyny przypadek,
                    // gdy tekst dobiera kolor do tła — biel albo tusz,
                    // zależnie od jasności segmentu.
                    color: ThemeData.estimateBrightnessForColor(color) ==
                            Brightness.dark
                        ? Colors.white
                        : VizColors.inkPrimaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.segments, required this.brightness});

  final List<({Productivity p, Duration d})> segments;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final s in segments)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: VizColors.forProductivity(s.p, brightness),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              // Tekst legendy w tokenie tekstowym, nigdy w kolorze serii —
              // jasne odcienie są nieczytelne jako tekst na tle.
              Text(
                '${productivityLabel(s.p)} · ${formatDuration(s.d)}',
                style: TextStyle(
                  fontSize: 12,
                  color: VizColors.inkSecondary(brightness),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyBar extends StatelessWidget {
  const _EmptyBar({required this.height, required this.brightness});

  final double height;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: VizColors.emptyCell(brightness),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        'Brak zmierzonego czasu',
        style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
      ),
    );
  }
}

/// Mapa doby: 24 komórki, jedna na godzinę.
///
/// Kodowanie sekwencyjne — jeden odcień, więcej znaczy ciemniej. To zadanie
/// „porównaj wielkość", a nie „odróżnij serie", więc paleta kategoryczna
/// byłaby tu błędem: kolor musi nieść wartość, nie tożsamość.
class HourHeatmap extends StatelessWidget {
  const HourHeatmap({
    required this.buckets,
    this.label = 'Aktywność wg godziny',
    super.key,
  });

  /// 24 wartości, indeks = godzina lokalna.
  final List<Duration> buckets;
  final String label;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final maxSeconds = buckets.fold<int>(
      0,
      (m, d) => d.inSeconds > m ? d.inSeconds : m,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: VizColors.ink(brightness),
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 2.0;
            final cell = (constraints.maxWidth - gap * 23) / 24;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var h = 0; h < 24; h++) ...[
                      if (h > 0) const SizedBox(width: gap),
                      Tooltip(
                        message: '${h.toString().padLeft(2, '0')}:00 — '
                            '${formatDuration(buckets[h])}',
                        child: Container(
                          width: cell,
                          height: 26,
                          decoration: BoxDecoration(
                            color: maxSeconds == 0 || buckets[h].inSeconds == 0
                                ? VizColors.emptyCell(brightness)
                                : VizColors.sequential(
                                    buckets[h].inSeconds / maxSeconds,
                                    brightness,
                                  ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Podpisy co sześć godzin — pełne 24 etykiety nie mieszczą
                // się na telefonie i zlewają w szarą kreskę.
                Row(
                  children: [
                    for (var h = 0; h < 24; h++) ...[
                      if (h > 0) const SizedBox(width: gap),
                      SizedBox(
                        width: cell,
                        child: h % 6 == 0
                            ? Text(
                                '$h',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: VizColors.inkMuted,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Trend jednej wartości w czasie — samoocena sesji po sesji.
///
/// Pojedyncza seria, więc **bez legendy**: tytuł nad wykresem mówi, co jest
/// rysowane, a ramka z jednym kolorem tylko powtarzałaby tę informację.
/// Etykietowana jest wyłącznie ostatnia wartość — liczba przy każdym punkcie
/// zamienia wykres w tabelę i przestaje być czytana.
class RatingTrend extends StatelessWidget {
  const RatingTrend({
    required this.values,
    required this.color,
    this.min = 1,
    this.max = 5,
    super.key,
  });

  final List<int> values;
  final Color color;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // Dwa punkty to jeszcze nie trend. Poniżej tego progu wykres
    // sugerowałby kierunek, którego w danych nie ma.
    if (values.length < 3) {
      return Text(
        'Za mało ocen na trend (${values.length}/3).',
        style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
      );
    }

    return SizedBox(
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomPaint(
              painter: _SparklinePainter(
                values: values,
                color: color,
                gridColor: VizColors.grid(brightness),
                min: min,
                max: max,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Center(
            child: Text(
              '${values.last}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: VizColors.ink(brightness),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.gridColor,
    required this.min,
    required this.max,
  });

  final List<int> values;
  final Color color;
  final Color gridColor;
  final int min;
  final int max;

  @override
  void paint(Canvas canvas, Size size) {
    final range = (max - min).clamp(1, 1000);

    // Linia bazowa w połowie skali — pozwala od razu zobaczyć,
    // czy oceny są powyżej, czy poniżej środka.
    final baseline = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      baseline,
    );

    final path = Path();
    final step = values.length == 1 ? 0.0 : size.width / (values.length - 1);

    for (var i = 0; i < values.length; i++) {
      final normalized = (values[i] - min) / range;
      final x = step * i;
      final y = size.height - normalized * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        // 2 px, zaokrąglone łączenia — zgodnie ze specyfikacją znaczników.
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // Kropka na ostatnim punkcie z obwódką w kolorze tła, żeby była
    // czytelna także tam, gdzie linia ją przecina.
    final lastNormalized = (values.last - min) / range;
    final lastPoint = Offset(
      size.width,
      size.height - lastNormalized * size.height,
    );
    canvas.drawCircle(lastPoint, 6, Paint()..color = gridColor);
    canvas.drawCircle(lastPoint, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values || old.color != color;
}

/// Ranking poziomy: aplikacje albo kategorie posortowane wg czasu.
///
/// Kolor niesie wielkość (rampa sekwencyjna), a nie tożsamość — przy liście
/// „na co poszedł czas" pytanie brzmi „ile", nie „które".
class RankedBars extends StatelessWidget {
  const RankedBars({
    required this.rows,
    this.maxRows = 8,
    super.key,
  });

  final List<({String label, Duration value, Color? accent})> rows;
  final int maxRows;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (rows.isEmpty) {
      return Text(
        'Brak danych',
        style: TextStyle(fontSize: 12, color: VizColors.inkMuted),
      );
    }

    final visible = rows.take(maxRows).toList();
    final max = visible.first.value.inSeconds.clamp(1, 1 << 31);

    return Column(
      children: [
        for (final row in visible)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    row.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: VizColors.inkSecondary(brightness),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final fraction = row.value.inSeconds / max;
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: (c.maxWidth * fraction).clamp(2.0, c.maxWidth),
                          // Słupek najwyżej 24 px grubości — reszta pasma
                          // zostaje powietrzem.
                          height: 16,
                          decoration: BoxDecoration(
                            color: row.accent ??
                                VizColors.sequential(fraction, brightness),
                            // Zaokrąglony koniec danych, prosty przy osi.
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(4),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 64,
                  child: Text(
                    formatDuration(row.value),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: VizColors.inkSecondary(brightness),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../ui/helpers/helpers.dart';

class ChartPrices extends StatelessWidget {
  final List<DateAndValueModel> datesAndValues;

  const ChartPrices({super.key, required this.datesAndValues});

  @override
  Widget build(BuildContext context) {
    final leftReservedSize = MediaQuery.of(context).size.width * 0.10;

    return Column(
      spacing: 16,
      children: [
        _ChartTitle(bitcoinPriceHistory: datesAndValues),
        AspectRatio(
          aspectRatio: 1.4,
          child: LineChart(
            transformationConfig: FlTransformationConfig(
              scaleAxis: FlScaleAxis.horizontal,
              minScale: 1.0,
              maxScale: 10.0,
              panEnabled: false,
              scaleEnabled: false,
              transformationController: null,
            ),
            LineChartData(
              minY: datesAndValues
                      .map((e) => e.value)
                      .reduce((a, b) => a < b ? a : b) /
                  1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: datesAndValues.asMap().entries.map((e) {
                    final index = e.key;
                    final item = e.value;
                    return FlSpot(index.toDouble(), item.value);
                  }).toList(),
                  dotData: const FlDotData(show: false),
                  color: Theme.of(context).secondaryHeaderColor,
                  barWidth: 0.6,
                  shadow: Shadow(
                    color: Theme.of(context).secondaryHeaderColor,
                    blurRadius: 2,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(
                          context,
                        ).secondaryHeaderColor.withValues(alpha: 0.2),
                        Theme.of(
                          context,
                        ).secondaryHeaderColor.withValues(alpha: 0.0),
                      ],
                      stops: const [0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchSpotThreshold: 5,
                getTouchLineStart: (_, __) => -double.infinity,
                getTouchLineEnd: (_, __) => double.infinity,
                getTouchedSpotIndicator: (
                  LineChartBarData barData,
                  List<int> spotIndexes,
                ) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      const FlLine(
                        color: Colors.red,
                        strokeWidth: 1.5,
                        dashArray: [8, 2],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Theme.of(context).secondaryHeaderColor,
                            strokeWidth: 0,
                            strokeColor: Theme.of(context).secondaryHeaderColor,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final price = barSpot.y;
                      final date = datesAndValues[barSpot.x.toInt()].date;

                      return LineTooltipItem(
                        '',
                        TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: DateFormat('dd/MM/yyyy').format(date),
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\n${price.toString().toBrazilianNumber().addBrazilianCoin()}',
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  getTooltipColor: (LineBarSpot barSpot) =>
                      Theme.of(context).primaryColorDark,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                  axisNameSize: 10,
                  axisNameWidget: Text(''),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  drawBelowEverything: true,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: leftReservedSize,
                    maxIncluded: false,
                    minIncluded: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    maxIncluded: true,
                    minIncluded: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      final date = datesAndValues[index].date;
                      return SideTitleWidget(
                        meta: meta,
                        child: Transform.rotate(
                          angle: -45 * 3.14 / 180,
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            duration: Duration.zero,
          ),
        ),
      ],
    );
  }
}

class _ChartTitle extends StatelessWidget {
  final List<DateAndValueModel> bitcoinPriceHistory;

  const _ChartTitle({required this.bitcoinPriceHistory});

  String getOldestAndNewestDates() {
    final oldest = bitcoinPriceHistory
        .map((e) => e.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final newest = bitcoinPriceHistory
        .map((e) => e.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    return "${DateFormat('dd/MM/yyyy').format(oldest)} ~ ${DateFormat('dd/MM/yyyy').format(newest)}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getOldestAndNewestDates(),
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

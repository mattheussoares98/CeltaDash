import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

class ChartPie extends StatefulWidget {
  final List<PieParameter> pieParameters;
  final int? quantityToShow;
  final BoxShape? itemsShape;
  final EdgeInsetsGeometry? paddingItems;
  const ChartPie({
    super.key,
    required this.pieParameters,
    this.itemsShape = BoxShape.circle,
    this.quantityToShow,
    this.paddingItems,
  });

  @override
  State<ChartPie> createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPie> {
  int? selectedIndex;
  double indicatorSize = 16;
  final colors = [
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.deepOrange,
    Colors.red,
    Colors.brown,
    Colors.teal,
    Colors.cyanAccent,
  ];

  bool needBreakLoop(int index) =>
      index > (widget.quantityToShow ?? 4) || (index + 1) > colors.length;
  List<PieChartSectionData> getSections(double chartWidth) {
    final totalOfAllPieParameters = widget.pieParameters.fold(
      0.0,
      (p, e) => p + e.value,
    );

    List<PieChartSectionData> sections = [];

    for (var i = 0; i < widget.pieParameters.length; i++) {
      final isTouched = i == selectedIndex;
      final chartSize = chartWidth;
      final fontSize = isTouched ? 16.0 : 13.0;
      final radius = isTouched ? chartSize * 0.29 : chartSize * 0.25;

      if (needBreakLoop(i)) {
        break;
      }

      final pieParameter = widget.pieParameters[i];
      sections.add(
        PieChartSectionData(
          color: colors[i],
          value: pieParameter.value,
          title:
              "${(pieParameter.value / totalOfAllPieParameters * 100).toString().toBrazilianNumber(0)}%",
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return sections;
  }

  List<_Indicator> getIndicators() {
    List<_Indicator> indicators = [];
    for (var i = 0; i < widget.pieParameters.length; i++) {
      if (needBreakLoop(i)) {
        break;
      }

      final pieParameter = widget.pieParameters[i];
      indicators.add(
        _Indicator(
          title: pieParameter.title,
          value: pieParameter.value,
          padding: widget.paddingItems,
          color: colors[i],
          boxShape: widget.itemsShape!,
          isSelected: i == selectedIndex,
          indicatorSize: indicatorSize,
          changeSelectedIndex: () {
            setState(() {
              selectedIndex = i;
            });
          },
        ),
      );
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    final chartWidth = MediaQuery.of(context).size.width * 0.4;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: chartWidth,
            height: chartWidth,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        selectedIndex = -1;
                        return;
                      }
                      selectedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: null,
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: getSections(chartWidth),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: indicatorSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getIndicators(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String title;
  final BoxShape? boxShape;
  final EdgeInsetsGeometry? padding;
  final void Function() changeSelectedIndex;
  final bool isSelected;
  final double indicatorSize;
  final double value;

  const _Indicator({
    required this.color,
    required this.title,
    required this.boxShape,
    required this.padding,
    required this.changeSelectedIndex,
    required this.isSelected,
    required this.indicatorSize,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        changeSelectedIndex();
      },
      child: GestureDetector(
        onTap: changeSelectedIndex,
        child: Padding(
          padding: padding ?? const EdgeInsets.only(bottom: 4),
          child: Row(
            children: <Widget>[
              Container(
                width: isSelected ? indicatorSize * 1.3 : indicatorSize,
                height: isSelected ? indicatorSize * 1.3 : indicatorSize,
                decoration: BoxDecoration(
                  shape: boxShape ?? BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "\n${value.toString().toBrazilianNumber().addBrazilianCoin()}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieParameter {
  final double value;
  final String title;

  PieParameter({required this.value, required this.title});
}

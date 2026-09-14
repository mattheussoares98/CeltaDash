import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class MonthlyAnalysisChart extends StatelessWidget {
  const MonthlyAnalysisChart({super.key, required this.days});

  final List<MonthlyAnalysisDayState> days;

  @override
  Widget build(BuildContext context) {
    return PeriodLineChart(
      dates: days.map((day) => day.date).toList(growable: false),
      height: MediaQuery.heightOf(context) * 0.33,
      series: [
        PeriodLineChartSeries(
          values: days.map((day) => day.value).toList(growable: false),
          color: context.theme.primaryColor,
        ),
      ],
      title: '${days.first.date.formatDate()} ~ ${days.last.date.formatDate()}',
    );
  }
}

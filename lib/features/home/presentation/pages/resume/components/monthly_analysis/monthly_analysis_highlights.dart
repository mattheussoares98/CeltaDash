import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:flutter/material.dart';

class MonthlyAnalysisHighlights extends StatelessWidget {
  const MonthlyAnalysisHighlights({
    super.key,
    required this.bestDay,
    required this.worstDay,
  });

  final MonthlyAnalysisDayState bestDay;
  final MonthlyAnalysisDayState worstDay;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: MonthlyAnalysisHighlight(day: bestDay, isBest: true)),
      Expanded(child: MonthlyAnalysisHighlight(day: worstDay, isBest: false)),
    ],
  );
}

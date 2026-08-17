import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class MonthlyAnalysisContent extends StatelessWidget {
  const MonthlyAnalysisContent({super.key, required this.analysis});

  final MonthlyAnalysisState analysis;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.title(
            'Análise mensal'.hardcoded.toUpperCase(),
            textAlign: .center,
          ),
          //TODO use wrap or BaseRich
          Row(
            children: [
              Expanded(
                child: MonthlyAnalysisSummary(
                  title: 'Total de vendas'.hardcoded,
                  value: analysis.totalSales,
                ),
              ),
              gapW4,
              Expanded(
                child: MonthlyAnalysisSummary(
                  title: 'Venda média diária'.hardcoded,
                  value: analysis.averageDailySale,
                ),
              ),
            ],
          ),
          MonthlyAnalysisHighlights(
            bestDay: analysis.bestDay!,
            worstDay: analysis.worstDay!,
          ),
          MonthlyAnalysisChart(days: analysis.days),
        ],
      ),
    ),
  );
}

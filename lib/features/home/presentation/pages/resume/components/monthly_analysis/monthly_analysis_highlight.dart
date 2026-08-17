import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class MonthlyAnalysisHighlight extends StatelessWidget {
  const MonthlyAnalysisHighlight({
    super.key,
    required this.day,
    required this.isBest,
  });

  final MonthlyAnalysisDayState day;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final color = isBest
        ? context.theme.primaryColor
        : context.theme.colorScheme.error;
    return Column(
      children: [
        BaseText.title(
          (isBest ? 'Melhor dia do mês' : 'Pior dia do mês').hardcoded,
          textAlign: TextAlign.center,
          color: color,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isBest
                  ? Icons.sentiment_satisfied_alt
                  : Icons.sentiment_dissatisfied_rounded,
              color: color,
            ),
            gapW8,
            BaseText.title(day.date.formatDate(.ddMM), color: color),
          ],
        ),
        BaseRichText(
          color: color,
          texts: [
            BaseText.caption('R\$ '),
            BaseText.title(day.value.toString().toBrazilianNumber()),
          ],
        ),
      ],
    );
  }
}

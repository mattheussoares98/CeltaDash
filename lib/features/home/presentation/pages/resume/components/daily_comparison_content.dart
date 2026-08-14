import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class DailyComparisonContent extends StatelessWidget {
  const DailyComparisonContent({super.key, required this.comparison});

  final DailyComparisonState comparison;

  @override
  Widget build(BuildContext context) {
    final percentage = comparison.percentageDifference;
    final todayColor = percentage >= 0 ? Colors.green : Colors.red;
    final prevColor = context.theme.colorScheme.secondary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.titleLarge(
              '${'Vendas do dia'.hardcoded.toUpperCase()} '
              '(${percentage.toString().toBrazilianNumber(0)}%)',
              textAlign: TextAlign.center,
              color: todayColor,
            ),
            gapH12,
            ChartPieWidget(
              showTotalAmount: false,
              centerDate: comparison.selectedDate,
              centerPassedColor: context.theme.disabledColor.withAlpha(40),
              centerRemainingColor: context.theme.colorScheme.surface,
              pieParameters: [
                PieParameter(
                  value: comparison.selectedLiquidValue.toDouble(),
                  color: todayColor,
                  title: DailyComparisonChartTitle(
                    liquidValue: comparison.selectedLiquidValue,
                    color: todayColor,
                  ),
                  subtitle: DailyComparisonChartSubtitle(
                    customers: comparison.selectedCustomers,
                    averageTicket: comparison.selectedAverageTicket,
                  ),
                ),
                PieParameter(
                  value: comparison.comparisonLiquidValue.toDouble(),
                  color: prevColor,
                  showSubtitleOnlyOnTap: true,
                  title: DailyComparisonChartTitle(
                    date: comparison.comparisonDate,
                    liquidValue: comparison.comparisonLiquidValue,
                    color: prevColor,
                  ),
                  subtitle: DailyComparisonChartSubtitle(
                    customers: comparison.comparisonCustomers,
                    averageTicket: comparison.comparisonAverageTicket,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class DailyComparisonContent extends StatelessWidget {
  const DailyComparisonContent({super.key, required this.comparison});

  final DailyComparisonState comparison;

  @override
  Widget build(BuildContext context) {
    final percentage = comparison.percentageDifference;
    final percentageColor = percentage >= 0
        ? context.theme.colorScheme.primary
        : context.theme.colorScheme.error;

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
              color: percentageColor,
            ),
            gapH24,
            ChartPieWidget(
              showTotalAmount: false,
              centerDate: comparison.selectedDate,
              centerPassedColor: context.theme.colorScheme.outline,
              centerRemainingColor: context.theme.colorScheme.surface,
              pieParameters: [
                PieParameter(
                  value: comparison.selectedLiquidValue.toDouble(),
                  color: percentageColor,
                  title: DailyComparisonChartTitle(
                    liquidValue: comparison.selectedLiquidValue,
                    color: percentageColor,
                  ),
                  subtitle: DailyComparisonChartSubtitle(
                    customers: comparison.selectedCustomers,
                    averageTicket: comparison.selectedAverageTicket,
                  ),
                ),
                PieParameter(
                  value: comparison.comparisonLiquidValue.toDouble(),
                  color: context.theme.colorScheme.secondary,
                  showSubtitleOnlyOnTap: true,
                  title: DailyComparisonChartTitle(
                    date: comparison.comparisonDate,
                    liquidValue: comparison.comparisonLiquidValue,
                    color: context.theme.colorScheme.secondary,
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

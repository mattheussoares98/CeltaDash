import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class MonthlyGoalInfoContent extends StatelessWidget {
  const MonthlyGoalInfoContent({
    super.key,
    required this.comparison,
    this.cachedGoal,
  });

  final MonthlyGoalComparisonState comparison;
  final MonthlyGoalEntity? cachedGoal;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateTime(
      comparison.comparisonDate.year,
      comparison.comparisonDate.month,
    ).formatDate(.yM);
    final daysInMonth = comparison.customMonthlyGoal == null
        ? comparison.comparisonMonthDays
        : comparison.selectedMonthDays;

    final author = cachedGoal?.userName ?? comparison.customMonthlyGoalAuthor;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'META MENSAL'.hardcoded,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH8,
                  if (comparison.customMonthlyGoal == null) ...[
                    TitleAndSubTitle(
                      title: 'Meta'.hardcoded,
                      subTitle: 'Vendas de ($formattedDate) + 5%'.hardcoded,
                    ),
                    gapH4,
                    TitleAndSubTitle(
                      title: 'Vendas de ($formattedDate)'.hardcoded,
                      subTitle: comparison.comparisonLiquidValue.toDouble(),
                      subTitleIsPrice: true,
                    ),
                    gapH4,
                    TitleAndSubTitle(
                      title: '5%'.hardcoded,
                      subTitle: (comparison.comparisonLiquidValue * 0.05)
                          .toDouble(),
                      subTitleIsPrice: true,
                    ),
                    gapH4,
                    TitleAndSubTitle(
                      title: 'Total'.hardcoded,
                      subTitle: comparison.monthlyGoal,
                      subTitleIsPrice: true,
                    ),
                  ] else ...[
                    TitleAndSubTitle(
                      title: 'Meta manual inserida'.hardcoded,
                      subTitle: comparison.monthlyGoal,
                      subTitleIsPrice: true,
                    ),
                    if (author != null && author.isNotEmpty) ...[
                      gapH4,
                      Text(
                        'Alterado por: $author'.hardcoded,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          gapH8,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'META DIÁRIA'.hardcoded,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH8,
                  TitleAndSubTitle(
                    title: 'Meta'.hardcoded,
                    subTitle: 'Meta mensal / dias no mês'.hardcoded,
                  ),
                  gapH4,
                  TitleAndSubTitle(
                    title: 'Meta mensal'.hardcoded,
                    subTitle: comparison.monthlyGoal,
                    subTitleIsPrice: true,
                  ),
                  gapH4,
                  TitleAndSubTitle(
                    title: 'Dias no mês'.hardcoded,
                    subTitle: daysInMonth,
                  ),
                  gapH4,
                  TitleAndSubTitle(
                    title: 'Total'.hardcoded,
                    subTitle: comparison.dailyGoal,
                    subTitleIsPrice: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/features/home/presentation/pages/financial/resume/components/monthly_chart/financial_monthly_chart_card.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FinancialMonthlyChartCard extends ConsumerWidget {
  const FinancialMonthlyChartCard({
    super.key,
    required this.enterpriseId,
    required this.selectedDate,
  });

  final int enterpriseId;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeFinancialControllerProvider(
      enterpriseId,
      HomeFinancialPeriod.daily,
    );
    final responseAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: responseAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (response) {
        final portions = response.financialTitlePortions;
        final grouped = groupBy(
          portions,
          (FinancialTitleDataRowEntity p) => p.date?.day ?? 0,
        );

        final daysInMonth = DateTime(
          selectedDate.year,
          selectedDate.month + 1,
          0,
        ).day;

        final days = <FinancialMonthlyAnalysisDayState>[];
        for (var day = 1; day <= daysInMonth; day++) {
          final group = grouped[day] ?? [];
          final receive = group.fold<double>(
            0,
            (sum, p) => sum + (p.receiveLiquidValue?.toDouble() ?? 0),
          );
          final pay = group.fold<double>(
            0,
            (sum, p) => sum + (p.payLiquidValue?.toDouble() ?? 0),
          );
          days.add(
            FinancialMonthlyAnalysisDayState(
              date: DateTime(selectedDate.year, selectedDate.month, day),
              receiveValue: receive,
              payValue: pay,
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BaseText.titleLarge(
                  'Movimentação mensal'.hardcoded.toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                gapH8,
                FinancialMonthlyChart(days: days),
              ],
            ),
          ),
        );
      },
    );
  }
}

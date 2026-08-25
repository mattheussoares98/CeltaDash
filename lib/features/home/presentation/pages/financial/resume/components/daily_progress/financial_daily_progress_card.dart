// lib/features/home/presentation/pages/financial/resume/components/daily_progress/financial_daily_progress_card.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FinancialDailyProgressCard extends ConsumerWidget {
  const FinancialDailyProgressCard({
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
        final matchingPortions = portions.where(
          (p) =>
              p.date?.year == selectedDate.year &&
              p.date?.month == selectedDate.month &&
              p.date?.day == selectedDate.day,
        );

        final receive = matchingPortions.fold<double>(
          0,
          (sum, p) => sum + (p.receiveLiquidValue?.toDouble() ?? 0),
        );
        final pay = matchingPortions.fold<double>(
          0,
          (sum, p) => sum + (p.payLiquidValue?.toDouble() ?? 0),
        );

        return FinancialDailyProgressContent(
          selectedDate: selectedDate,
          receiveValue: receive,
          payValue: pay,
        );
      },
    );
  }
}

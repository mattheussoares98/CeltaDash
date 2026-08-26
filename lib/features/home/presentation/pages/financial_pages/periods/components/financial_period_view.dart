part of './financial_periods_content.dart';

class _FinancialPeriodView extends ConsumerWidget {
  const _FinancialPeriodView({
    required this.enterpriseId,
    required this.period,
    required this.selectedDate,
  });

  final int enterpriseId;
  final HomeFinancialPeriod period;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeFinancialControllerProvider(enterpriseId, period);
    final responseAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: responseAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (response) {
        final portions = response.financialTitlePortions;
        if (portions.isEmpty) {
          return Center(child: BaseText('Nenhum título encontrado'.hardcoded));
        }

        return switch (period) {
          HomeFinancialPeriod.daily => _DailyFinancialTable(
            portions: portions,
            selectedDate: selectedDate,
            refreshProvider: provider,
            isLoading: responseAsync.isLoading,
          ),
          HomeFinancialPeriod.monthly => _MonthlyFinancialTable(
            portions: portions,
            selectedDate: selectedDate,
            refreshProvider: provider,
            isLoading: responseAsync.isLoading,
          ),
          // HomeFinancialPeriod.yearly => _YearlyFinancialTable(
          //   portions: portions,
          //   refreshProvider: provider,
          //   isLoading: responseAsync.isLoading,
          // ),
        };
      },
    );
  }
}

// lib/features/home/presentation/pages/sales/components/sales_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

part 'tables/daily_sales_table.dart';
part 'tables/hourly_sales_table.dart';
part 'tables/monthly_sales_table.dart';
part 'tables/yearly_sales_table.dart';

class SalesContent extends HookConsumerWidget {
  const SalesContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(HomeSalesPeriod.hourly);
    final visitedPeriods = useState<Set<HomeSalesPeriod>>({
      HomeSalesPeriod.hourly,
    });
    //! only build the respective period when it was opened

    return Column(
      children: [
        NewBaseSegmentedButtons(
          items: HomeSalesPeriod.values,
          selectedValue: selectedPeriod.value,
          onChanged: (value) {
            selectedPeriod.value = value;
            visitedPeriods.value.add(value);
          },
          itemLabelBuilder: (value) => value.label,
        ),
        gapH8,
        Expanded(
          child: Consumer(
            builder: (_, ref, _) {
              final selectedDate = ref.watch(
                homeControllerProvider.select(
                  (value) => value.value?.selectedDate ?? DateTime.now(),
                ),
              );

              return IndexedStack(
                index: selectedPeriod.value.index,
                children: [
                  for (final period in HomeSalesPeriod.values)
                    if (visitedPeriods.value.contains(period))
                      _SalesPeriodView(
                        enterpriseId: enterpriseId,
                        period: period,
                        selectedDate: selectedDate,
                      )
                    else
                      const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SalesPeriodView extends ConsumerWidget {
  const _SalesPeriodView({
    required this.enterpriseId,
    required this.period,
    required this.selectedDate,
  });

  final int enterpriseId;
  final HomeSalesPeriod period;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeSalesControllerProvider(enterpriseId, period);
    final statisticsAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: statisticsAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (statistics) {
        if (statistics.isEmpty) {
          return Center(child: BaseText('Nenhuma venda encontrada'.hardcoded));
        }

        return switch (period) {
          HomeSalesPeriod.hourly => _HourlySalesTable(
            statistics: statistics,
            refreshProvider: provider,
            isLoading: statisticsAsync.isLoading,
          ),
          HomeSalesPeriod.daily => _DailySalesTable(
            statistics: statistics,
            selectedDate: selectedDate,
            refreshProvider: provider,
            isLoading: statisticsAsync.isLoading,
          ),
          HomeSalesPeriod.monthly => _MonthlySalesTable(
            statistics: statistics,
            selectedDate: selectedDate,
            refreshProvider: provider,
            isLoading: statisticsAsync.isLoading,
          ),
          HomeSalesPeriod.yearly => _YearlySalesTable(
            statistics: statistics,
            refreshProvider: provider,
            isLoading: statisticsAsync.isLoading,
          ),
        };
      },
    );
  }
}

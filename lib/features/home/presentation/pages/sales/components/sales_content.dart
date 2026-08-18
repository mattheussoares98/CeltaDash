// lib/features/home/presentation/pages/sales/components/sales_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final selectedPeriod = useState(SalesPeriod.hourly);
    final provider = salesControllerProvider(
      enterpriseId,
      selectedPeriod.value,
    );

    final selectedDate = ref.watch(
      homeControllerProvider.select(
        (value) => value.value?.selectedDate ?? DateTime.now(),
      ),
    );

    return Column(
      children: [
        NewBaseSegmentedButtons(
          items: SalesPeriod.values,
          selectedValue: selectedPeriod.value,
          onChanged: (value) => selectedPeriod.value = value,
          itemLabelBuilder: (value) => value.label,
        ),
        gapH8,
        Expanded(
          child: Consumer(
            builder: (_, ref, _) {
              final statisticsAsync = ref.watch(provider);

              return AsyncValueWidget(
                value: statisticsAsync,
                preserveValue: true,
                tryAgain: () => ref.invalidate(provider),
                data: (statistics) {
                  if (statistics.isEmpty) {
                    return Center(
                      child: BaseText('Nenhuma venda encontrada'.hardcoded),
                    );
                  }

                  return switch (selectedPeriod.value) {
                    SalesPeriod.hourly => _HourlySalesTable(
                      statistics: statistics,
                      isLoading: statisticsAsync.isLoading,
                    ),
                    SalesPeriod.daily => _DailySalesTable(
                      statistics: statistics,
                      selectedDate: selectedDate,
                      isLoading: statisticsAsync.isLoading,
                    ),
                    SalesPeriod.monthly => _MonthlySalesTable(
                      statistics: statistics,
                      selectedDate: selectedDate,
                      isLoading: statisticsAsync.isLoading,
                    ),
                    SalesPeriod.yearly => _YearlySalesTable(
                      statistics: statistics,
                      isLoading: statisticsAsync.isLoading,
                    ),
                  };
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

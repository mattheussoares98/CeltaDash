// lib/features/home/presentation/pages/financial/components/financial_periods_content.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

part 'financial_period_view.dart';
part 'tables/daily_financial_table.dart';
part 'tables/monthly_financial_table.dart';

class FinancialPeriodsContent extends HookConsumerWidget {
  const FinancialPeriodsContent({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(HomeFinancialPeriod.daily);
    final visitedPeriods = useState<Set<HomeFinancialPeriod>>({
      HomeFinancialPeriod.daily,
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          child: Wrap(
            alignment: .center,
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            crossAxisAlignment: .center,
            children: [
              NewBaseSegmentedButtons(
                items: HomeFinancialPeriod.values,
                selectedValue: selectedPeriod.value,
                onChanged: (value) {
                  selectedPeriod.value = value;
                  visitedPeriods.value.add(value);
                },
                itemLabelBuilder: (value) => value.label,
              ),
              const FinancialSituationSelector(),
              const FinancialPeriodTypeSelector(),
            ],
          ),
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
                  for (final period in HomeFinancialPeriod.values)
                    if (visitedPeriods.value.contains(period))
                      _FinancialPeriodView(
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

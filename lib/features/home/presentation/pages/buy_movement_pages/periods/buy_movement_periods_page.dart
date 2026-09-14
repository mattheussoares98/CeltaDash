import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/periods/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementPeriodsPage extends StatelessWidget {
  const BuyMovementPeriodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterpriseGuard(
      preserveValue: true,
      builder: (context, enterpriseId) =>
          _BuyMovementPeriodsContent(enterpriseId: enterpriseId),
    );
  }
}

class _BuyMovementPeriodsContent extends HookConsumerWidget {
  const _BuyMovementPeriodsContent({required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const periods = [
      HomeBuyMovementPeriod.daily,
      HomeBuyMovementPeriod.weekly,
      HomeBuyMovementPeriod.monthly,
      HomeBuyMovementPeriod.yearly,
    ];
    final selectedPeriod = useState(HomeBuyMovementPeriod.daily);
    final visitedPeriods = useState(<HomeBuyMovementPeriod>{
      selectedPeriod.value,
    });

    return Column(
      children: [
        Padding(
          padding: const .symmetric(vertical: Sizes.p4),
          child: NewBaseSegmentedButtons<HomeBuyMovementPeriod>(
            items: periods,
            selectedValue: selectedPeriod.value,
            onChanged: (period) {
              selectedPeriod.value = period;
              visitedPeriods.value = {...visitedPeriods.value, period};
            },
            itemLabelBuilder: (period) => period.label,
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: periods.indexOf(selectedPeriod.value),
            children: [
              for (final period in periods)
                if (visitedPeriods.value.contains(period))
                  BuyMovementPeriodView(
                    enterpriseId: enterpriseId,
                    period: period,
                  )
                else
                  const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

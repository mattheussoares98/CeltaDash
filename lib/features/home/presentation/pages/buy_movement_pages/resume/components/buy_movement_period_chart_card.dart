import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/resume/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementPeriodChartCard extends ConsumerWidget {
  const BuyMovementPeriodChartCard({
    required this.enterpriseId,
    required this.period,
    required this.title,
    super.key,
  });

  final int enterpriseId;
  final HomeBuyMovementPeriod period;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeBuyMovementControllerProvider(enterpriseId, period);
    final value = ref.watch(provider);
    return AsyncValueWidget(
      value: value,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseText.titleLarge(
                title.toUpperCase(),
                textAlign: TextAlign.center,
              ),
              gapH4,
              BaseText.title(
                state.totalValue.toString().toBRL().addBrazilianCoin(),
                textAlign: TextAlign.center,
              ),
              gapH8,
              BuyMovementPeriodChart(rows: state.rows),
            ],
          ),
        ),
      ),
    );
  }
}

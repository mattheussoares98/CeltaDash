import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DailyComparisonCard extends ConsumerWidget {
  const DailyComparisonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    return AsyncValueWidget(
      value: homeAsync,
      tryAgain: () => ref.invalidate(homeControllerProvider),
      data: (homeState) {
        final enterpriseId = homeState.selectedEnterpriseId;
        if (enterpriseId == null) {
          return Center(
            child: BaseText.bodyLarge(
              'Selecione uma empresa para visualizar o resumo'.hardcoded,
              textAlign: TextAlign.center,
            ),
          );
        }

        final provider = dailyComparisonControllerProvider(enterpriseId);
        final comparisonAsync = ref.watch(provider);
        return AsyncValueWidget(
          value: comparisonAsync,
          tryAgain: () => ref.invalidate(provider),
          data: (comparison) => DailyComparisonContent(comparison: comparison),
        );
      },
    );
  }
}

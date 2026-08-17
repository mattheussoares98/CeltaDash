import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonthlyGoalComparisonCard extends ConsumerWidget {
  const MonthlyGoalComparisonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(
      homeControllerProvider.select((s) => s.value?.selectedEnterpriseId),
    );
    if (enterpriseId == null) {
      //Shouldn't happen because it is being treated on ResumePage file
      return const SizedBox.shrink();
    }
    final provider = monthlyGoalComparisonControllerProvider(enterpriseId);
    final comparisonAsync = ref.watch(provider);
    final comparison = comparisonAsync.value;
    if (comparison != null) {
      return comparison.hasGoal
          ? MonthlyGoalComparisonContent(comparison: comparison)
          : Center(
              child: BaseText.bodyLarge(
                'Não há dados para calcular as metas'.hardcoded,
                textAlign: TextAlign.center,
              ),
            );
    }
    return AsyncValueWidget(
      value: comparisonAsync,
      tryAgain: () => ref.invalidate(provider),
      data: (comparison) => comparison.hasGoal
          ? MonthlyGoalComparisonContent(comparison: comparison)
          : Center(
              child: BaseText.bodyLarge(
                'Não há dados para calcular as metas'.hardcoded,
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}

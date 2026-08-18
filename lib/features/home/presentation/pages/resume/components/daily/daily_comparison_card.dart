import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DailyComparisonCard extends ConsumerWidget {
  const DailyComparisonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(
      homeControllerProvider.select((s) => s.value?.selectedEnterpriseId),
    );
    if (enterpriseId == null) {
      //Shouldn't happen because it is being treated on ResumePage file
      return const SizedBox.shrink();
    }
    final provider = dailyComparisonControllerProvider(enterpriseId);
    final comparisonAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: comparisonAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (comparison) => DailyComparisonContent(comparison: comparison),
    );
  }
}

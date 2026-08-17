import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonthlyAnalysisCard extends ConsumerWidget {
  const MonthlyAnalysisCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(
      homeControllerProvider.select((s) => s.value?.selectedEnterpriseId),
    );
    if (enterpriseId == null) {
      //Shouldn't happen because it is being treated on ResumePage file
      return const SizedBox.shrink();
    }

    final provider = monthlyAnalysisControllerProvider(enterpriseId);
    final analysisAsync = ref.watch(provider);
    final analysis = analysisAsync.value;
    if (analysis != null) {
      return analysis.hasAnalysis
          ? MonthlyAnalysisContent(analysis: analysis)
          : const SizedBox.shrink();
    }
    return AsyncValueWidget(
      value: analysisAsync,
      tryAgain: () => ref.invalidate(provider),
      data: (analysis) => analysis.hasAnalysis
          ? MonthlyAnalysisContent(analysis: analysis)
          : const SizedBox.shrink(),
    );
  }
}

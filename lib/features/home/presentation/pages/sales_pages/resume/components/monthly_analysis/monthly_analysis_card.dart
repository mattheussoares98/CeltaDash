import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonthlyAnalysisCard extends ConsumerWidget {
  const MonthlyAnalysisCard({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = monthlyAnalysisControllerProvider(enterpriseId);
    final analysisAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: analysisAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (analysis) => analysis.hasAnalysis
          ? MonthlyAnalysisContent(analysis: analysis)
          : const SizedBox.shrink(),
    );
  }
}

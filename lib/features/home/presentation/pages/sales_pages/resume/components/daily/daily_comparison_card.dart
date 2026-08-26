import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DailyComparisonCard extends ConsumerWidget {
  const DailyComparisonCard({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

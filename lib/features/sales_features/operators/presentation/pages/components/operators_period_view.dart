import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/operators/operators.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OperatorsPeriodView extends ConsumerWidget {
  const OperatorsPeriodView({
    required this.enterpriseId,
    required this.period,
    super.key,
  });

  final int enterpriseId;
  final OperatorsPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = operatorsControllerProvider(enterpriseId, period);
    final statisticsAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: statisticsAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (statistics) {
        if (statistics.isEmpty) {
          return Center(
            child: BaseText.error('Nenhuma venda encontrada'.hardcoded),
          );
        }

        return OperatorsTable(
          statistics: statistics,
          refreshProvider: provider,
          isLoading: statisticsAsync.isLoading,
        );
      },
    );
  }
}

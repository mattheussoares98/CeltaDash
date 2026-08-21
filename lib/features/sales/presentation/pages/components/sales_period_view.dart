import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales/presentation/models/models.dart';
import 'package:celta_dash/features/sales/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SalesPeriodView extends HookConsumerWidget {
  const SalesPeriodView({
    required this.enterpriseId,
    required this.period,
    required this.onlyCancelled,
    required this.actualPage,
    required this.onOnlyCancelledChanged,
    required this.onPageChanged,
    super.key,
  });

  final int enterpriseId;
  final SalesPeriod period;
  final bool onlyCancelled;
  final int actualPage;
  final ValueChanged<bool> onOnlyCancelledChanged;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = salesControllerProvider(
      enterpriseId,
      period,
      onlyCancelled,
      actualPage,
    );
    final salesAsync = ref.watch(provider);
    final previousResult = useRef(salesAsync.value);
    final currentResult = salesAsync.value;
    if (currentResult != null) previousResult.value = currentResult;
    final paginationResult = currentResult ?? previousResult.value;

    return Column(
      children: [
        SalesPaginationAndCancFilter(
          result: paginationResult,
          isLoading: salesAsync.isLoading,
          onlyCancelled: onlyCancelled,
          onOnlyCancelledChanged: onOnlyCancelledChanged,
          onPageChanged: onPageChanged,
        ),
        Expanded(
          child: AsyncValueWidget(
            value: salesAsync,
            preserveValue: true,
            tryAgain: () => ref.invalidate(provider),
            data: (result) {
              if (result.collection.isEmpty) {
                return Center(
                  child: BaseText.error(
                    'Nenhuma venda foi encontrada'.hardcoded,
                  ),
                );
              }
              return SalesTable(
                sales: result.collection,
                refreshProvider: provider,
                isLoading: salesAsync.isLoading,
                showCancellationDetails: onlyCancelled,
              );
            },
          ),
        ),
      ],
    );
  }
}

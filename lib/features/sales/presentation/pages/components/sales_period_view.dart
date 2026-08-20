import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales/presentation/models/models.dart';
import 'package:celta_dash/features/sales/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesPeriodView extends ConsumerWidget {
  const SalesPeriodView({
    required this.enterpriseId,
    required this.period,
    required this.onlyCancelled,
    required this.actualPage,
    required this.onPageChanged,
    super.key,
  });

  final int enterpriseId;
  final SalesPeriod period;
  final bool onlyCancelled;
  final int actualPage;
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

    return AsyncValueWidget(
      value: salesAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (result) {
        if (result.collection.isEmpty) {
          return Center(
            child: BaseText.error(
              (onlyCancelled
                      ? 'Nenhuma venda cancelada'
                      : 'Nenhuma venda não cancelada')
                  .hardcoded,
            ),
          );
        }
        return Column(
          children: [
            SalesPagination(
              result: result,
              isLoading: salesAsync.isLoading,
              onPageChanged: onPageChanged,
            ),
            Expanded(
              child: SalesTable(
                sales: result.collection,
                refreshProvider: provider,
                isLoading: salesAsync.isLoading,
                showCancellationDetails: onlyCancelled,
              ),
            ),
          ],
        );
      },
    );
  }
}

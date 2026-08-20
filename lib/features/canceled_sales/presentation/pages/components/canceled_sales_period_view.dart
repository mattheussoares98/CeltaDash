import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/canceled_sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/canceled_sales/presentation/models/models.dart';
import 'package:celta_dash/features/canceled_sales/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanceledSalesPeriodView extends ConsumerWidget {
  const CanceledSalesPeriodView({
    required this.enterpriseId,
    required this.period,
    super.key,
  });

  final int enterpriseId;
  final CanceledSalesPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = canceledSalesControllerProvider(enterpriseId, period);
    final salesAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: salesAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (result) {
        if (result.collection.isEmpty) {
          return Center(
            child: BaseText.error('Nenhuma venda cancelada'.hardcoded),
          );
        }
        return CanceledSalesTable(
          sales: result.collection,
          refreshProvider: provider,
          isLoading: salesAsync.isLoading,
        );
      },
    );
  }
}

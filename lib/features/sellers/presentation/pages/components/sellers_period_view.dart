// lib/features/sellers/presentation/pages/components/sellers_period_view.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sellers/sellers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellersPeriodView extends ConsumerWidget {
  const SellersPeriodView({
    required this.enterpriseId,
    required this.period,
    super.key,
  });

  final int enterpriseId;
  final SellersPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = sellersControllerProvider(enterpriseId, period);
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

        return SellersTable(
          statistics: statistics,
          refreshProvider: provider,
          isLoading: statisticsAsync.isLoading,
        );
      },
    );
  }
}

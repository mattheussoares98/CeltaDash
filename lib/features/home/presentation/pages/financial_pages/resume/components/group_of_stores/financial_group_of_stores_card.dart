// lib/features/home/presentation/pages/financial/resume/components/group_of_stores/financial_group_of_stores_card.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FinancialGroupOfStoresCard extends ConsumerWidget {
  const FinancialGroupOfStoresCard({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = financialGroupOfStoresControllerProvider(enterpriseId);
    final storesAsync = ref.watch(provider);

    return AsyncValueWidget<FinancialGroupOfStoresState>(
      value: storesAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (stores) => stores.hasMultipleEnterprises
          ? FinancialGroupOfStoresContent(stores: stores)
          : const SizedBox.shrink(),
    );
  }
}

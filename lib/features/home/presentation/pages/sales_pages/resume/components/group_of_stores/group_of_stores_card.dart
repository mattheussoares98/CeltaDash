import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupOfStoresCard extends ConsumerWidget {
  const GroupOfStoresCard({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = groupOfStoresControllerProvider(enterpriseId);
    final storesAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: storesAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (stores) => stores.hasMultipleEnterprises
          ? GroupOfStoresContent(stores: stores)
          : const SizedBox.shrink(),
    );
  }
}

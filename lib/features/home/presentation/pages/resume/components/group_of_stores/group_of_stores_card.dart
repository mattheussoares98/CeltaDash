import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupOfStoresCard extends ConsumerWidget {
  const GroupOfStoresCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(
      homeControllerProvider.select(
        (state) => state.value?.selectedEnterpriseId,
      ),
    );
    if (enterpriseId == null) {
      //Shouldn't happen because it is being treated on ResumePage file
      return const SizedBox.shrink();
    }

    final provider = groupOfStoresControllerProvider(enterpriseId);
    final storesAsync = ref.watch(provider);
    final stores = storesAsync.value;
    if (stores != null) {
      return stores.hasMultipleEnterprises
          ? GroupOfStoresContent(stores: stores)
          : const SizedBox.shrink();
    }
    return AsyncValueWidget(
      value: storesAsync,
      tryAgain: () => ref.invalidate(provider),
      data: (stores) => stores.hasMultipleEnterprises
          ? GroupOfStoresContent(stores: stores)
          : const SizedBox.shrink(),
    );
  }
}

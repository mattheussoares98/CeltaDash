import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/buy_movement_pages/components/components.dart';
import 'package:celta_dash/features/home/presentation/pages/sales_pages/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementHomePage extends HookConsumerWidget {
  const BuyMovementHomePage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(
      homeControllerProvider.select(
        (state) => state.value?.selectedEnterpriseId,
      ),
    );
    final isDisabled =
        enterpriseId != null &&
        ref.watch(
          enterprisesControllerProvider.select(
            (state) =>
                state.value
                    ?.firstWhereOrNull((item) => item.id == enterpriseId)
                    ?.enabled ==
                false,
          ),
        );
    final providers = enterpriseId == null
        ? null
        : <ProviderBase<AsyncValue<dynamic>>>[
            homeBuyMovementControllerProvider(
              enterpriseId,
              HomeBuyMovementPeriod.hourly,
            ),
            homeBuyMovementControllerProvider(
              enterpriseId,
              HomeBuyMovementPeriod.daily,
            ),
            buyMovementGroupOfStoresControllerProvider(enterpriseId),
            homeBuyMovementProductsControllerProvider(
              enterpriseId,
              HomeBuyMovementPeriod.hourly,
            ),
          ];

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      drawer: const HomeDrawer(),
      appBar: HomeAppBar(
        isLandscape: MediaQuery.orientationOf(context) == Orientation.landscape,
        showToggleAppMode: true,
        showEnterpriseManagement: true,
        reloadButton: ReloadIconButton(
          refreshProviders: isDisabled ? null : providers,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          navigationShell,
          if (isDisabled) const DisabledEnterpriseOverlay(),
        ],
      ),
      bottomNavigationBar: BuyMovementBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

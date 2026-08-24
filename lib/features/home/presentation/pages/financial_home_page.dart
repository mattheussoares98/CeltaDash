import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FinancialHomePage extends ConsumerWidget {
  const FinancialHomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final enterpriseId = ref.watch(
      homeControllerProvider.select(
        (state) => state.value?.selectedEnterpriseId,
      ),
    );
    final selectedEnterpriseIsDisabled =
        enterpriseId != null &&
        ref.watch(
          enterprisesControllerProvider.select(
            (state) =>
                state.value
                    ?.firstWhereOrNull(
                      (enterprise) => enterprise.id == enterpriseId,
                    )
                    ?.enabled ==
                false,
          ),
        );

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      drawer: const HomeDrawer(),
      appBar: HomeAppBar(
        isLandscape: isLandscape,
        showToggleAppMode: true,
        showEnterpriseManagement: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          navigationShell,
          if (selectedEnterpriseIsDisabled) const DisabledEnterpriseOverlay(),
        ],
      ),
    );
  }
}

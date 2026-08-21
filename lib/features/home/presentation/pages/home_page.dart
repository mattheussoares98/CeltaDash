import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showHomeAppBar = navigationShell.currentIndex <= 2;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final enterpriseId = ref.watch(
      homeControllerProvider.select((s) => s.value?.selectedEnterpriseId),
    );
    final selectedEnterpriseIsDisabled =
        enterpriseId != null &&
        ref.watch(
          enterprisesControllerProvider.select(
            (s) =>
                s.value
                    ?.firstWhereOrNull((e) => e.id == enterpriseId)
                    ?.enabled ==
                false,
          ),
        );
    final providers = enterpriseId == null
        ? null
        : <ProviderBase<AsyncValue<dynamic>>>[
            dailyComparisonControllerProvider(enterpriseId),
            monthlyGoalComparisonControllerProvider(enterpriseId),
            monthlyAnalysisControllerProvider(enterpriseId),
            groupOfStoresControllerProvider(enterpriseId),
          ];

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      drawer: const HomeDrawer(),
      appBar: showHomeAppBar
          ? HomeAppBar(
              isLandscape: isLandscape,
              showToggleAppMode: true,
              showEnterpriseManagement: true,
              reloadButton: ReloadIconButton(
                onRefresh: providers == null
                    ? null
                    : () => ref.invalidate(resumeCurrentDateProvider),
                refreshProviders: providers,
              ),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          navigationShell,
          const ResumeProvidersListener(),
          if (selectedEnterpriseIsDisabled) const DisabledEnterpriseOverlay(),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final showHomeAppBar = navigationShell.currentIndex <= 2;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final enterpriseId = homeState.value?.selectedEnterpriseId;
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
      body: navigationShell,
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

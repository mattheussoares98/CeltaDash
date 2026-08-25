// lib/features/home/presentation/pages/financial_home_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FinancialHomePage extends HookConsumerWidget {
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

    final providers = enterpriseId == null
        ? null
        : <ProviderBase<AsyncValue<dynamic>>>[
            homeFinancialControllerProvider(
              enterpriseId,
              HomeFinancialPeriod.daily,
            ),
            homeFinancialControllerProvider(
              enterpriseId,
              HomeFinancialPeriod.monthly,
            ),
            financialGroupOfStoresControllerProvider(enterpriseId),
          ];

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      drawer: const HomeDrawer(),
      appBar: HomeAppBar(
        isLandscape: isLandscape,
        showToggleAppMode: true,
        showEnterpriseManagement: true,
        reloadButton: ReloadIconButton(
          onRefresh: providers == null || selectedEnterpriseIsDisabled
              ? null
              : () => ref.invalidate(resumeCurrentDateProvider),
          refreshProviders: selectedEnterpriseIsDisabled ? null : providers,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          navigationShell,
          if (selectedEnterpriseIsDisabled) const DisabledEnterpriseOverlay(),
        ],
      ),
      bottomNavigationBar: navigationShell.route.branches.length >= 2
          ? FinancialBottomNavigation(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            )
          : null,
    );
  }
}


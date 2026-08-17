import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({
    required this.isLandscape,
    this.showReload = true,
    super.key,
  });

  final bool isLandscape;
  final bool showReload;

  @override
  Size get preferredSize =>
      Size.fromHeight(isLandscape ? kToolbarHeight : Sizes.p100);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    ref.listen(
      homeControllerProvider.select((value) => value.value?.selectionError),
      (previous, next) {
        if (next == null || next == previous) return;
        showToastMessage(next.hardcoded, type: ToastType.error);
        ref.read(homeControllerProvider.notifier).clearSelectionError();
      },
    );

    const enterpriseSelector = HomeEnterpriseSelector();
    const dateSelector = Expanded(child: HomeDateSelector());
    const modeToggle = Flexible(child: HomeModeToggle());
    final selectEnterprise = BaseIconButton(
      key: const ValueKey('home_enterprises_manager'),
      onPressed: () => context.pushNamed(Routes.enterprisesManager.name),
      platformIcon: const PlatformIcon(
        materialIcon: Icons.manage_accounts,
        cupertinoIcon: CupertinoIcons.person_2,
      ),
    );

    final controls = AsyncValueWidget(
      value: homeAsync,
      tryAgain: () => ref.invalidate(homeControllerProvider),
      data: (homeState) {
        final enterpriseId = homeState.selectedEnterpriseId;

        final providers = enterpriseId == null
            ? null
            : <ProviderBase<AsyncValue<dynamic>>>[
                dailyComparisonControllerProvider(enterpriseId),
                monthlyGoalComparisonControllerProvider(enterpriseId),
                monthlyAnalysisControllerProvider(enterpriseId),
                groupOfStoresControllerProvider(enterpriseId),
              ];

        final reloadIconButton = context.isMobile || !showReload
            ? null
            : ReloadIconButton(
                onRefresh: providers == null
                    ? null
                    : () => ref.invalidate(resumeCurrentDateProvider),
                refreshProviders: providers,
              );
        if (MediaQuery.orientationOf(context) == Orientation.landscape) {
          return Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              const Expanded(flex: 2, child: enterpriseSelector),
              dateSelector,
              gapW8,
              modeToggle,
              selectEnterprise,
              ?reloadIconButton,
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                const Expanded(child: enterpriseSelector),
                selectEnterprise,
              ],
            ),
            gapH4,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [dateSelector, modeToggle, ?reloadIconButton],
            ),
          ],
        );
      },
    );

    return BaseAppBar(
      showLeading: false,
      titleWidget: controls,
      actionsPadding: EdgeInsets.symmetric(
        vertical: isLandscape ? Sizes.p8 : Sizes.p24,
      ),
    );
  }
}

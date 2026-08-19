import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({
    required this.isLandscape,
    this.reloadButton,
    this.showLeading = true,
    this.showToggleAppMode = false,
    this.showEnterpriseManagement = false,
    this.showEnterpriseDropdown = true,
    this.leading,
    super.key,
  });

  final bool isLandscape;
  final ReloadIconButton? reloadButton;
  final bool showLeading;
  final bool showToggleAppMode;
  final bool showEnterpriseManagement;
  final bool showEnterpriseDropdown;
  final Widget? leading;

  @override
  Size get preferredSize => Size.fromHeight(isLandscape ? kToolbarHeight : 95);

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

    final enterpriseSelector = showEnterpriseDropdown
        ? const HomeEnterpriseSelector()
        : null;
    const dateSelector = Expanded(child: HomeDateSelector());
    final modeToggle = showToggleAppMode
        ? const Flexible(child: HomeModeToggle())
        : null;
    final selectEnterprise = showEnterpriseManagement
        ? BaseIconButton(
            key: const ValueKey('home_enterprises_manager'),
            onPressed: () => context.pushNamed(Routes.enterprisesManager.name),
            platformIcon: const PlatformIcon(
              materialIcon: Icons.manage_accounts,
              cupertinoIcon: CupertinoIcons.person_2,
            ),
          )
        : null;
    final drawerButton = showLeading
        ? leading ??
              Builder(
                builder: (context) => BaseIconButton(
                  key: const ValueKey('home_drawer_button'),
                  platformIcon: const PlatformIcon(
                    materialIcon: Icons.menu,
                    cupertinoIcon: CupertinoIcons.bars,
                  ),
                  onPressed: Scaffold.of(context).openDrawer,
                ),
              )
        : null;

    final controls = AsyncValueWidget(
      value: homeAsync,
      tryAgain: () => ref.invalidate(homeControllerProvider),
      data: (homeState) {
        if (MediaQuery.orientationOf(context) == Orientation.landscape) {
          return Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              ?drawerButton,
              if (enterpriseSelector != null)
                Expanded(flex: 2, child: enterpriseSelector),
              dateSelector,
              gapW8,
              ?modeToggle,
              ?selectEnterprise,
              ?reloadButton,
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                ?drawerButton,
                if (enterpriseSelector != null)
                  Expanded(child: enterpriseSelector),
              ],
            ),
            gapH4,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                dateSelector,
                ?modeToggle,
                ?selectEnterprise,
                ?reloadButton,
              ],
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

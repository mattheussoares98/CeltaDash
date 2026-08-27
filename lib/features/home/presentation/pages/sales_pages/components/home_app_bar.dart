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
    this.showSelectDate = true,
    this.leading,
    this.leftDateWidget,
    super.key,
  });

  final bool isLandscape;
  final ReloadIconButton? reloadButton;
  final bool showLeading;
  final bool showToggleAppMode;
  final bool showEnterpriseManagement;
  final bool showEnterpriseDropdown;
  final bool showSelectDate;
  final Widget? leading;
  final Widget? leftDateWidget;

  bool get _showBottomLine =>
      showToggleAppMode ||
      showEnterpriseManagement ||
      showSelectDate ||
      reloadButton != null;

  @override
  Size get preferredSize => Size.fromHeight(
    (isLandscape || !_showBottomLine || !showEnterpriseDropdown)
        ? kToolbarHeight
        : 95,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    ref.listen(homeControllerProvider, (p, n) {
      n.showToastOnError(context, p);
    });

    final enterpriseSelector = showEnterpriseDropdown
        ? const HomeEnterpriseSelector()
        : null;
    final dateSelector = showSelectDate
        ? const Expanded(child: HomeDateSelector())
        : null;
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

    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final showReloadButton = !PlatformUtil.isMobile;

    final Widget controls;
    if (homeAsync is AsyncData) {
      if (isLandscape) {
        controls = Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            ?drawerButton,
            if (enterpriseSelector != null)
              Expanded(flex: 2, child: enterpriseSelector),
            ?leftDateWidget, //TODO test all pages with this widget
            gapW4,
            ?dateSelector,
            ?modeToggle,
            ?selectEnterprise,
            if (showReloadButton) ?reloadButton,
          ],
        );
      } else {
        controls = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .stretch,
            children: [
              if (enterpriseSelector != null) ...[
                Row(
                  children: [
                    ?drawerButton,
                    Expanded(child: enterpriseSelector),
                  ],
                ),
                gapH4,
              ],
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  if (enterpriseSelector == null) ?drawerButton,
                  ?leftDateWidget,
                  ?dateSelector,
                  ?modeToggle,
                  ?selectEnterprise,
                  if (showReloadButton) ?reloadButton,
                ],
              ),
            ],
          ),
        );
      }
    } else {
      final fallbackAsync = AsyncValueWidget(
        value: homeAsync,
        errorMaxLines: 1,
        tryAgain: () {
          ref.invalidate(enterprisesControllerProvider);
          ref.invalidate(homeControllerProvider);
        },
        data: (_) => const SizedBox.shrink(),
      );

      controls = Row(
        children: [
          ?drawerButton,
          Expanded(child: fallbackAsync),
        ],
      );
    }

    return BaseAppBar(
      showLeading: false,
      titleWidget: controls,
      actionsPadding: EdgeInsets.symmetric(
        vertical: this.isLandscape ? Sizes.p8 : Sizes.p24,
      ),
    );
  }
}

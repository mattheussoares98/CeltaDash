import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeControllerProvider);
    final showHomeAppBar = navigationShell.currentIndex <= 2;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      appBar: showHomeAppBar ? HomeAppBar(isLandscape: isLandscape) : null,
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

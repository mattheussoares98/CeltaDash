import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> homeRoutes(
  GlobalKey<NavigatorState> rootNavigatorKey,
  List<RouteBase> secondaryRoutes, {
  required Future<AppMode> Function() loadAppMode,
}) => [
  salesHomeRoute(
    resumeRoutes: [
      paymentsTypeRoute(rootNavigatorKey),
      departmentsRoute(rootNavigatorKey),
      groupSummaryRoute(rootNavigatorKey),
    ],
  ),
  financialHomeRoute(),
  buyMovementHomeRoute(),
  buyMovementHomeDepartmentsRoute(),
  ...secondaryRoutes,
  GoRoute(
    path: '/home',
    name: Routes.home.name,
    redirect: (context, state) async {
      final homeLocation = state.namedLocation(Routes.home.name);
      if (state.uri.path != homeLocation) return null;

      final appMode = await loadAppMode();
      return state.namedLocation(switch (appMode) {
        AppMode.sales => Routes.salesHomeResume.name,
        AppMode.financialTitles => Routes.financialHomeResume.name,
        AppMode.buyMovements => Routes.buyMovementHomeResume.name,
      });
    },
  ),
];

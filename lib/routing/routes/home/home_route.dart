import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> homeRoutes(
  GlobalKey<NavigatorState> rootNavigatorKey,
  List<RouteBase> secondaryRoutes,
) => [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) =>
        HomePage(navigationShell: navigationShell),
    branches: [
      StatefulShellBranch(
        routes: [
          homeResumeRoute([
            paymentsTypeRoute(rootNavigatorKey),
            departmentsRoute(rootNavigatorKey),
            groupSummaryRoute(rootNavigatorKey),
          ]),
        ],
      ),
      StatefulShellBranch(routes: [homeSalesRoute()]),
      StatefulShellBranch(routes: [homeProductsRoute()]),
      StatefulShellBranch(routes: [homePersonalizedRoute()]),
      StatefulShellBranch(routes: [homeMoreRoute()]),
    ],
  ),
  ...secondaryRoutes,
  GoRoute(
    path: '/home',
    name: Routes.home.name,
    redirect: (context, state) {
      final homeLocation = state.namedLocation(Routes.home.name);
      return state.uri.path == homeLocation
          ? state.namedLocation(Routes.homeResume.name)
          : null;
    },
  ),
];

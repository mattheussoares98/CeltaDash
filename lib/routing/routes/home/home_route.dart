import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> homeRoutes(List<RouteBase> secondaryRoutes) => [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) =>
        HomePage(navigationShell: navigationShell),
    branches: [
      StatefulShellBranch(routes: [homeResumeRoute()]),
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
    redirect: (context, state) => state.namedLocation(Routes.homeResume.name),
  ),
];

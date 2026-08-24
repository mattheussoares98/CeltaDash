import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase salesHomeRoute({required List<RouteBase> resumeRoutes}) =>
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomePage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [salesHomeResumeRoute(resumeRoutes)]),
        StatefulShellBranch(routes: [salesHomeSalesRoute()]),
        StatefulShellBranch(routes: [salesHomeProductsRoute()]),
      ],
    );

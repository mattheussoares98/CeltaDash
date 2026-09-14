import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase buyMovementHomeRoute() => StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      BuyMovementHomePage(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [buyMovementHomeResumeRoute()]),
    StatefulShellBranch(routes: [buyMovementHomePeriodsRoute()]),
    StatefulShellBranch(routes: [buyMovementHomeProductsRoute()]),
    StatefulShellBranch(routes: [buyMovementHomeDepartmentsRoute()]),
  ],
);

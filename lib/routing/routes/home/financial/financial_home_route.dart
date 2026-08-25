// lib/routing/routes/home/financial/financial_home_route.dart
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase financialHomeRoute() => StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      FinancialHomePage(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [financialHomeResumeRoute()]),
    StatefulShellBranch(routes: [financialHomePeriodsRoute()]),
  ],
);

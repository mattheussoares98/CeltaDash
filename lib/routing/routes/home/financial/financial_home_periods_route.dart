// lib/routing/routes/home/financial/financial_home_periods_route.dart
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase financialHomePeriodsRoute() => GoRoute(
  path: '/home/financial/periods',
  name: Routes.financialHomePeriods.name,
  builder: (context, state) => const FinancialPeriodsPage(),
);

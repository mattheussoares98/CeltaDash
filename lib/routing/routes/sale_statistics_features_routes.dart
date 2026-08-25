import 'package:celta_dash/features/enterprises_manager/presentation/presentation.dart'
    as enterprises_manager;
import 'package:celta_dash/features/sales_features/compare_months/presentation/presentation.dart'
    as compare_months;
import 'package:celta_dash/features/sales_features/goal_historic/presentation/presentation.dart'
    as goal_historic;
import 'package:celta_dash/features/sales_features/presentation/presentation.dart'
    as compare_days;
import 'package:celta_dash/features/sales_features/sales/presentation/pages/pages.dart'
    as sales;
import 'package:celta_dash/features/splash/presentation/presentation.dart'
    as splash;
import 'package:celta_dash/features/web_enterprises/presentation/presentation.dart'
    as web_enterprises;
import 'package:celta_dash/routing/routes.dart';
import 'package:go_router/go_router.dart';

RouteBase compareDaysRoute() => GoRoute(
  path: '/home/compare-days',
  name: Routes.compareDays.name,
  builder: (context, state) => const compare_days.CompareDaysPage(),
);

RouteBase compareMonthsRoute() => GoRoute(
  path: '/home/compare-months',
  name: Routes.compareMonths.name,
  builder: (context, state) => const compare_months.CompareMonthsPage(),
);

RouteBase enterprisesManagerRoute() => GoRoute(
  path: '/home/enterprises-manager',
  name: Routes.enterprisesManager.name,
  builder: (context, state) =>
      const enterprises_manager.EnterprisesManagerPage(),
);

RouteBase goalHistoricRoute() => GoRoute(
  path: '/home/goal-historic',
  name: Routes.goalHistoric.name,
  builder: (context, state) => const goal_historic.GoalHistoricPage(),
);

RouteBase notSalesRoute() => GoRoute(
  path: '/home/not-canceled-sales',
  name: Routes.notSales.name,
  builder: (context, state) => const sales.SalesPage(),
);

RouteBase updateAppVersionRoute() => GoRoute(
  path: '/home/update-app-version',
  name: Routes.updateAppVersion.name,
  builder: (context, state) => const splash.UpdateAppVersionPage(),
);

RouteBase webEnterpriseDetailsRoute() => GoRoute(
  path: '/home/web-enterprise-details',
  name: Routes.webEnterpriseDetails.name,
  builder: (context, state) => const web_enterprises.WebEnterprisesPage(),
);

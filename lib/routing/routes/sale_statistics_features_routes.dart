import 'package:go_router/go_router.dart';

import 'package:celta_dash/main/factories/factories.dart';
import 'package:celta_dash/routing/routes.dart';
import 'package:celta_dash/ui/pages/pages.dart';

RouteBase appAnalyticsRoute() => GoRoute(
  path: '/home/app-analytics',
  name: Routes.appAnalytics.name,
  builder: (context, state) => makeAppAnalyticsPage(),
);

RouteBase compareDaysRoute() => GoRoute(
  path: '/home/compare-days',
  name: Routes.compareDays.name,
  builder: (context, state) => makeCompareDaysPage(),
);

RouteBase compareMonthsRoute() => GoRoute(
  path: '/home/compare-months',
  name: Routes.compareMonths.name,
  builder: (context, state) => makeCompareMonthsPage(),
);

RouteBase enterprisesManagerRoute() => GoRoute(
  path: '/home/enterprises-manager',
  name: Routes.enterprisesManager.name,
  builder: (context, state) => makeEnterprisesManagerPage(),
);

RouteBase goalHistoricRoute() => GoRoute(
  path: '/home/goal-historic',
  name: Routes.goalHistoric.name,
  builder: (context, state) => makeGoalHistoricPage(),
);

RouteBase moreRoute() => GoRoute(
  path: 'more',
  name: Routes.more.name,
  builder: (context, state) => makeMorePage(),
);

RouteBase notCanceledSalesRoute() => GoRoute(
  path: '/home/not-canceled-sales',
  name: Routes.notCanceledSales.name,
  builder: (context, state) => makeNotCanceledSalesPage(),
);

RouteBase setGoalRoute() => GoRoute(
  path: '/home/set-goal',
  name: Routes.setGoal.name,
  builder: (context, state) => const SetGoalPage(),
);

RouteBase updateAppVersionRoute() => GoRoute(
  path: '/home/update-app-version',
  name: Routes.updateAppVersion.name,
  builder: (context, state) => makeUpdateAppVersionPage(),
);

RouteBase webEnterprisesRoute() => GoRoute(
  path: '/home/web-enterprises',
  name: Routes.webEnterprises.name,
  builder: (context, state) => makeWebEnterprisesPage(),
);

RouteBase webEnterpriseDetailsRoute() => GoRoute(
  path: '/home/web-enterprise-details',
  name: Routes.webEnterpriseDetails.name,
  builder: (context, state) => makeWebEnterpriseDetailsPage(),
);

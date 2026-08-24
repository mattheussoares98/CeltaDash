import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase salesHomeSalesRoute() => GoRoute(
  path: '/home/sales',
  name: Routes.salesHomeSales.name,
  builder: (context, state) => const SalesPage(),
);

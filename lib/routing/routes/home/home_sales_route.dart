import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase homeSalesRoute() => GoRoute(
  path: '/home/sales',
  name: Routes.homeSales.name,
  builder: (context, state) => const SalesPage(),
);

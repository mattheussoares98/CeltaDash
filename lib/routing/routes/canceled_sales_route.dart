import 'package:celta_dash/features/sales_features/sales/presentation/pages/pages.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase salesRoute() => GoRoute(
  path: '/home/canceled-sales',
  name: Routes.sales.name,
  builder: (context, state) => const SalesPage(),
);

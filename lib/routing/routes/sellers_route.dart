// lib/routing/routes/sellers/sellers_route.dart
import 'package:celta_dash/features/sales_features/sellers/sellers.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase sellersRoute() => GoRoute(
  path: '/home/sellers',
  name: Routes.sellers.name,
  builder: (context, state) => const SellersPage(),
);

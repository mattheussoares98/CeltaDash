import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase homeProductsRoute() => GoRoute(
  path: '/home/products',
  name: Routes.homeProducts.name,
  builder: (context, state) => const ProductsPage(),
);

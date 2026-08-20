import 'package:celta_dash/features/canceled_sales/presentation/pages/pages.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase canceledSalesRoute() => GoRoute(
  path: '/home/canceled-sales',
  name: Routes.canceledSales.name,
  builder: (context, state) => const CanceledSalesPage(),
);

import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase buyMovementHomeDepartmentsRoute() => GoRoute(
  path: '/home/buy-movements/departments',
  name: Routes.buyMovementHomeDepartments.name,
  builder: (context, state) => const BuyMovementDepartmentsPage(),
);

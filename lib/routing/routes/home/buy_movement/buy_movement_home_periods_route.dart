import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase buyMovementHomePeriodsRoute() => GoRoute(
  path: '/home/buy-movements/periods',
  name: Routes.buyMovementHomePeriods.name,
  builder: (context, state) => const BuyMovementPeriodsPage(),
);

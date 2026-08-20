import 'package:celta_dash/features/operators/operators.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase operatorsRoute() => GoRoute(
  path: '/home/operators',
  name: Routes.operators.name,
  builder: (context, state) => const OperatorsPage(),
);

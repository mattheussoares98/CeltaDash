import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase homeMoreRoute() => GoRoute(
  path: '/home/more',
  name: Routes.homeMore.name,
  builder: (context, state) => const MorePage(),
);

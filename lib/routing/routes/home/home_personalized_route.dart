import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase homePersonalizedRoute() => GoRoute(
  path: 'personalized',
  name: Routes.homePersonalized.name,
  builder: (context, state) => const PersonalizedPage(),
);

import 'package:go_router/go_router.dart';

import 'package:celta_dash/features/splash/splash.dart';
import 'package:celta_dash/routing/routes.dart';

RouteBase splashRoute() => GoRoute(
  path: '/splash',
  name: Routes.splash.name,
  builder: (context, state) => const SplashPage(),
);

import 'package:go_router/go_router.dart';

import 'package:celta_dash/main/factories/factories.dart';
import 'package:celta_dash/routing/routes.dart';

RouteBase homeRoute(List<RouteBase> routes) => GoRoute(
      path: '/home',
      name: Routes.home.name,
      builder: (context, state) => makeHomePage(),
      routes: routes,
    );

import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

RouteBase homeRoute(List<RouteBase> secondaryRoutes) => GoRoute(
  path: '/home',
  name: Routes.home.name,
  redirect: (context, state) => state.uri.path == '/home'
      ? state.namedLocation(Routes.homeResume.name)
      : null,
  builder: (context, state) => const SizedBox.shrink(),
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          HomePage(currentLocation: state.uri.path, child: child),
      routes: [
        homeResumeRoute(),
        homeSalesRoute(),
        homeProductsRoute(),
        homePersonalizedRoute(),
        homeMoreRoute(),
      ],
    ),
    ...secondaryRoutes,
  ],
);

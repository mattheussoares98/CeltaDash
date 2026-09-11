import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/core/presentation/presentation.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/web_login/providers.dart';
import 'package:celta_dash/routing/not_found_page.dart';
import 'package:celta_dash/routing/routes/routes.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authNotifier = ValueNotifier<bool?>(
    ref
        .read(activeEcParamsStateControllerProvider)
        .whenOrNull(data: (params) => params != null),
  );
  ref.listen(activeEcParamsStateControllerProvider, (_, next) {
    final isLoggedIn = next.whenOrNull(data: (params) => params != null);
    if (isLoggedIn != null) authNotifier.value = isLoggedIn;
  });
  ref.onDispose(authNotifier.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      // 1. While auth state is loading from storage, allow initial navigation
      final isLoggedIn = authNotifier.value;
      if (isLoggedIn == null) return null;

      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login';
      final isUpdateRequired = location == '/home/update-app-version';
      final isPublicRoute = isSplash || isLogin || isUpdateRequired;

      // 2. Unauthenticated user trying to access a protected route
      if (!isLoggedIn) {
        if (isPublicRoute) return null;
        return '/splash';
      }

      // 3. Authenticated user trying to access login routes
      if (isLogin) {
        return '/home';
      }

      return null;
    },
    routes: [
      splashRoute(),
      loginRoute(),
      ...homeRoutes(rootNavigatorKey, [
        saleDetailsRoute(),
        salesRoute(),
        compareDaysRoute(),
        compareMonthsRoute(),
        enterprisesManagerRoute(),
        goalHistoricRoute(),
        homePersonalizedRoute(),
        notSalesRoute(),
        operatorsRoute(),
        sellersRoute(),
        updateAppVersionRoute(),
        webLoginRoute(
          isLoggedIn: () => ref.read(webLoginRepositoryProvider).isLoggedIn(),
        ),
        webEnterprisesRoute(),
        webEnterpriseDetailsRoute(),
      ], loadAppMode: () => ref.read(homeRepositoryProvider).loadAppMode()),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
    observers: [CrashlyticsRouteObserver(ref.read(crashlyticsServiceProvider))],
  );
}

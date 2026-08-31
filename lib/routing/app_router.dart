import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/presentation/presentation.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/not_found_page.dart';
import 'package:celta_dash/routing/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authNotifier = ValueNotifier<AsyncValue<EcParams?>>(
    ref.read(activeEcParamsStateControllerProvider),
  );
  ref.listen(
    activeEcParamsStateControllerProvider,
    (_, next) => authNotifier.value = next,
  );
  ref.onDispose(authNotifier.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(activeEcParamsStateControllerProvider);

      // 1. While auth state is loading from storage, allow initial navigation
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login' || location == '/web-login';
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
      webLoginRoute(),
      ...homeRoutes(
        rootNavigatorKey,
        [
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
          webEnterprisesRoute(),
          webEnterpriseDetailsRoute(),
        ],
        loadAppMode: () => ref.read(homeRepositoryProvider).loadAppMode(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}

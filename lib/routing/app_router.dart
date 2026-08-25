import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/not_found_page.dart';
import 'package:celta_dash/routing/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class Bridge<T> extends ChangeNotifier {
  T? _value;
  T? get value => _value;
  set value(T? v) {
    if (!identical(v, _value)) {
      _value = v;
      notifyListeners();
    }
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_dash/routing/not_found_page.dart';
import 'package:celta_dash/routing/routes/routes.dart';

part 'app_router.g.dart';

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
    initialLocation: '/splash',
    routes: [
      splashRoute(),
      loginRoute(),
      webLoginRoute(),
      homeRoute([
        appAnalyticsRoute(),
        bsSaleDetailsRoute(),
        canceledSalesRoute(),
        compareDaysRoute(),
        compareMonthsRoute(),
        departmentsRoute(),
        enterprisesManagerRoute(),
        goalHistoricRoute(),
        groupSummaryRoute(),
        moreRoute(),
        notCanceledSalesRoute(),
        operatorsRoute(),
        paymentsTypeRoute(),
        sellersRoute(),
        setGoalRoute(),
        updateAppVersionRoute(),
        webEnterprisesRoute(),
        webEnterpriseDetailsRoute(),
      ]),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}

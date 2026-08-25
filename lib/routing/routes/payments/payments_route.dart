import 'package:celta_dash/features/sales_features/payments/payments.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

RouteBase paymentsTypeRoute(GlobalKey<NavigatorState> rootNavigatorKey) =>
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'payments-type',
      name: Routes.paymentsType.name,
      builder: (context, state) => const PaymentsPage(),
    );

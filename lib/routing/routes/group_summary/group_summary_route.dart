// lib/routing/routes/group_summary/group_summary_route.dart
import 'package:celta_dash/features/sales_features/group_summary/group_summary.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

RouteBase groupSummaryRoute(GlobalKey<NavigatorState> rootNavigatorKey) =>
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'group-summary',
      name: Routes.groupSummary.name,
      builder: (context, state) => const GroupSummaryPage(),
    );

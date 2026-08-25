// lib/routing/routes/departments/departments_route.dart
import 'package:celta_dash/features/sales_features/departments/departments.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

RouteBase departmentsRoute(GlobalKey<NavigatorState> rootNavigatorKey) =>
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'departments',
      name: Routes.departments.name,
      builder: (context, state) => const DepartmentsPage(),
    );

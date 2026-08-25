import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/routing/routing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

void main() {
  late GoRouter router;

  Future<void> pumpRouter(
    WidgetTester tester, {
    String initialLocation = '/home',
    AppMode appMode = AppMode.sales,
  }) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: [
        ...homeRoutes(navigatorKey, [
          GoRoute(
            path: '/home/operators',
            name: Routes.operators.name,
            builder: (context, state) =>
                const Scaffold(body: Text('Operators')),
          ),
        ], loadAppMode: () async => appMode),
      ],
      errorBuilder: (context, state) => const Scaffold(body: Text('Not found')),
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: ToastificationWrapper(
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  String currentPath() => router.routeInformationProvider.value.uri.path;

  testWidgets('/home redirects to the resume destination', (tester) async {
    await pumpRouter(tester);

    expect(currentPath(), '/home/resume');
  });

  testWidgets('/home redirects to the financial shell when persisted', (
    tester,
  ) async {
    await pumpRouter(tester, appMode: AppMode.financialTitles);

    expect(currentPath(), '/home/financial/resume');
    expect(find.byType(FinancialPeriodsPage), findsOneWidget);
  });


  testWidgets('each named destination supports a direct deep link', (
    tester,
  ) async {
    const destinations = [
      '/home/resume',
      '/home/sales',
      '/home/products',
      '/home/financial/resume',
      '/home/personalized',
      '/home/more',
    ];

    for (final destination in destinations) {
      await pumpRouter(tester, initialLocation: destination);

      expect(currentPath(), destination);
    }
  });

  testWidgets('bottom navigation changes both the page and route', (
    tester,
  ) async {
    await pumpRouter(tester);
    const destinations = [
      ('home_navigation_sales', '/home/sales'),
      ('home_navigation_products', '/home/products'),
      ('home_navigation_resume', '/home/resume'),
    ];

    for (final destination in destinations) {
      await tester.tap(find.byKey(ValueKey(destination.$1)));
      await tester.pumpAndSettle();

      expect(currentPath(), destination.$2);
    }
  });

  testWidgets('popping a secondary route restores the previous tab route', (
    tester,
  ) async {
    await pumpRouter(tester, initialLocation: '/home/sales');

    router.push('/home/operators');
    await tester.pumpAndSettle();
    expect(find.text('Operators'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(currentPath(), '/home/sales');
  });

  testWidgets('payments is nested under the resume route', (tester) async {
    await pumpRouter(tester);

    expect(
      router.namedLocation(Routes.paymentsType.name),
      '/home/resume/payments-type',
    );
  });

  testWidgets('an unknown home route renders the not-found page', (
    tester,
  ) async {
    await pumpRouter(tester, initialLocation: '/home/unknown');

    expect(find.text('Not found'), findsOneWidget);
  });
}

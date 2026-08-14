import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  Future<void> pumpRouter(
    WidgetTester tester, {
    String initialLocation = '/home',
  }) async {
    router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        ...homeRoutes([
          GoRoute(
            path: '/home/operators',
            name: Routes.operators.name,
            builder: (context, state) =>
                const Scaffold(body: Text('Operators')),
          ),
        ]),
      ],
      errorBuilder: (context, state) => const Scaffold(body: Text('Not found')),
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  String currentPath() => router.routeInformationProvider.value.uri.path;

  testWidgets('/home redirects to the resume destination', (tester) async {
    await pumpRouter(tester);

    expect(currentPath(), '/home/resume');
    expect(find.text('Resume'), findsWidgets);
  });

  testWidgets('each named destination supports a direct deep link', (
    tester,
  ) async {
    const destinations = {
      '/home/resume': 'Resume',
      '/home/sales': 'Sales',
      '/home/products': 'Products',
      '/home/personalized': 'Personalized',
      '/home/more': 'More',
    };

    for (final destination in destinations.entries) {
      await pumpRouter(tester, initialLocation: destination.key);

      expect(currentPath(), destination.key);
      expect(find.text(destination.value), findsWidgets);
    }
  });

  testWidgets('bottom navigation changes both the page and route', (
    tester,
  ) async {
    await pumpRouter(tester);
    const destinations = [
      ('home_navigation_sales', '/home/sales', 'Sales'),
      ('home_navigation_products', '/home/products', 'Products'),
      ('home_navigation_personalized', '/home/personalized', 'Personalized'),
      ('home_navigation_more', '/home/more', 'More'),
      ('home_navigation_resume', '/home/resume', 'Resume'),
    ];

    for (final destination in destinations) {
      await tester.tap(find.byKey(ValueKey(destination.$1)));
      await tester.pumpAndSettle();

      expect(currentPath(), destination.$2);
      expect(find.text(destination.$3), findsWidgets);
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
    expect(find.text('Sales'), findsWidgets);
  });

  testWidgets('an unknown home route renders the not-found page', (
    tester,
  ) async {
    await pumpRouter(tester, initialLocation: '/home/unknown');

    expect(find.text('Not found'), findsOneWidget);
  });
}

import 'package:celta_dash/features/web_login/providers.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockWebLoginRepository repository;
  late GoRouter router;

  Future<void> pumpRouter(
    WidgetTester tester, {
    required String initialLocation,
  }) async {
    router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/home-source',
          builder: (context, state) =>
              const Scaffold(body: Text('Home source')),
        ),
        GoRoute(
          path: '/login-source',
          builder: (context, state) =>
              const Scaffold(body: Text('Login source')),
        ),
        webLoginRoute(isLoggedIn: repository.isLoggedIn),
        GoRoute(
          path: '/home/web-enterprises',
          name: Routes.webEnterprises.name,
          builder: (context, state) =>
              const Scaffold(body: Text('Web enterprises')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [webLoginRepositoryProvider.overrideWithValue(repository)],
        child: ToastificationWrapper(
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    repository = MockWebLoginRepository();
    when(repository.isLoggedIn).thenAnswer((_) async => true);
  });

  testWidgets('closing Web Enterprises returns to Home', (tester) async {
    await pumpRouter(tester, initialLocation: '/home-source');

    router.pushNamed(Routes.webLogin.name);
    await tester.pumpAndSettle();
    expect(find.text('Web enterprises'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    expect(find.text('Home source'), findsOneWidget);
  });

  testWidgets('closing Web Enterprises returns to Login', (tester) async {
    await pumpRouter(tester, initialLocation: '/login-source');

    router.pushNamed(Routes.webLogin.name);
    await tester.pumpAndSettle();
    expect(find.text('Web enterprises'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    expect(find.text('Login source'), findsOneWidget);
  });

  testWidgets('shows Web Login when Firebase user is unauthenticated', (
    tester,
  ) async {
    when(repository.isLoggedIn).thenAnswer((_) async => false);

    await pumpRouter(tester, initialLocation: '/home/web-login');

    expect(find.text('Login web'), findsOneWidget);
    expect(find.text('Web enterprises'), findsNothing);
  });
}

import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../../presentation/mocks/enterprises_manager_presenter_spy.dart';
import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../navigation/navigation.dart';

void main() {
  late SplashPresenterSpy presenter;

  setUpAll(() {
    registerFallbackValue(FirebaseEnterpriseModel.fromEntity(
            EntityFactory.makeFirebaseEnterpriseEntity())
        .toViewModel());
    registerFallbackValue(EnterprisesManagerPresenterSpy());
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(
      makePage(
        path: PageRoutes.splash,
        page: () => SplashPage(presenter: presenter),
      ),
    );
  }

  testWidgets('Should present spinner on page load', (
    WidgetTester tester,
  ) async {
    await loadPage(tester);

    expect(find.byKey(const Key("loading")), findsOneWidget);
  });

  testWidgets('Should change to Login Page', (WidgetTester tester) async {
    await loadPage(tester);
    mockNavigation(routeName: PageRoutes.login);

    await tester.pumpAndSettle();

    expect(currentRoute, PageRoutes.login);
  });
}

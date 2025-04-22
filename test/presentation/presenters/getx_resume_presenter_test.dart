import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late GetxResumePresenter sut;

  late NavigateToSpy navigateTo;
  late LoadSaleMovementsSpy loadSaleMovements;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxResumePresenter(
      navigateTo: navigateTo,
      loadSaleMovements: loadSaleMovements,
    );
  }

  void initEntities() {}

  void initMockSuccess() {}

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });

  group("Navigate to", () {
    test("Should navigate to profitability correctly", () async {
      sut.goToProfitabillityPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.profitability),
      ).called(1);
    });
    test("Should navigate to daily analysis page correctly", () async {
      sut.goToCompareDays();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.compareDays),
      ).called(1);
    });
    test("Should navigate to sections page correctly", () async {
      sut.goToSectionsPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.sections),
      ).called(1);
    });
    test("Should navigate to set goal page correctly", () async {
      sut.goToSetGoalPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.setGoal),
      ).called(1);
    });
    test("Should navigate to types page correctly", () async {
      sut.goToPaymentsTypePage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.paymentsType),
      ).called(1);
    });
    test("Should navigate to group summary correctly", () async {
      sut.goToGroupSummaryPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.groupSummary),
      ).called(1);
    });
    test("Should navigate to goal history page correctly", () async {
      sut.goToGoalHistoryPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.goalHistory),
      ).called(1);
    });
  });
}

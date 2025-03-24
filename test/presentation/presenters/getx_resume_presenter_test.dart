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

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxResumePresenter(navigateTo: navigateTo);
  }

  void initEntitys() {}

  void initMockSuccess() {}

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
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
      sut.goToDailyAnalysisPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.dailyAnalysis),
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
      sut.goToTypesPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.types),
      ).called(1);
    });
  });
}

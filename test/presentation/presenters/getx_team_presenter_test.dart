import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late GetxTeamPresenter sut;

  late NavigateToSpy navigateTo;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxTeamPresenter(navigateTo: navigateTo);
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

  group("Navigation", () {
    test("Should navigate to operators discounts correctly", () {
      sut.goToOperatorsDiscountsPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.operatorsDiscounts),
      ).called(1);
    });
    test("Should navigate to operators chargebacks correctly", () {
      sut.goToOperatorsChargeBacksPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.operatorsChargeBacks),
      ).called(1);
    });

    test("Should navigate to operators productivity correctly", () {
      sut.goToOperatorsProductivityPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.operatorsProductivity),
      ).called(1);
    });

    test("Should navigate to operators sales correctly", () {
      sut.goToOperatorsSalesPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.operatorsSales),
      ).called(1);
    });

    test("Should navigate to sallers sales correctly", () {
      sut.goToSallersSalesPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.sallersSales),
      ).called(1);
    });
  });
}

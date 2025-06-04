import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxResumePresenter sut;
  late HomePresenterSpy homePresenter;

  late NavigateToSpy navigateTo;
  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntitys;

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
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleMovementEntitys = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementEntitys);
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetSalesParams());
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
      sut.goToDepartmentsPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.departments),
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

  group("Get sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getSales(homePresenter);
    });

    test("Should emit correct values on error", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      loadSaleMovements.mockGetError();

      await sut.getSales(homePresenter);
    });

    test("Should update sale movements correctly", () async {
      await sut.getSales(homePresenter);

      expect(
        sut.saleMovements,
        saleMovementEntitys
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });

    test("Should load sale movements with correct values", () async {
      await sut.getSales(homePresenter);

      DateTime startDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        1,
      );
      DateTime endDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month + 1,
        1,
      ).subtract(Duration(days: 1));

      verify(() => loadSaleMovements.get(
            GetSalesParams(
              startDate: startDate,
              endDate: endDate,
              groupByHour: true,
              groupByEnterprise: true,
            ),
          )).called(1);
    });

    test("Should update last date loaded data", () async {
      homePresenter.selectedDateMock = faker.date.dateTime();

      await sut.getSales(homePresenter);

      expect(sut.lastDateLoadedData, homePresenter.selectedDateMock);
    });
    test("Should not update last loaded data if loadSaleMovements throws",
        () async {
      loadSaleMovements.mockGetError();

      await sut.getSales(homePresenter);

      expect(sut.lastDateLoadedData, null);
    });
    test("Should not load sales again if dont change the month", () async {
      homePresenter.selectedDateMock = faker.date.dateTime();
      await sut.getSales(homePresenter);

      homePresenter.selectedDateMock = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        faker.date.dateTime().day,
      );

      await sut.getSales(homePresenter);

      verify(() => loadSaleMovements.get(
            GetSalesParams(
              startDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month,
                1,
              ),
              endDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month + 1,
                1,
              ).subtract(Duration(days: 1)),
              groupByHour: true,
              groupByEnterprise: true,
            ),
          )).called(1);
    });
    test("Should load sales again if force refresh", () async {
      homePresenter.selectedDateMock = faker.date.dateTime();
      await sut.getSales(homePresenter);

      homePresenter.selectedDateMock = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        faker.date.dateTime().day,
      );

      await sut.getSales(homePresenter, forceRefresh: true);

      verify(() => loadSaleMovements.get(
            GetSalesParams(
              startDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month,
                1,
              ),
              endDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month + 1,
                1,
              ).subtract(Duration(days: 1)),
              groupByHour: true,
              groupByEnterprise: true,
            ),
          )).called(2);
    });
  });
}

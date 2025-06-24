import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
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
  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxResumePresenter(
      navigateTo: navigateTo,
      loadSaleStatistics: loadSaleStatistics,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleStatisticsEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticsEntities);
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
    test("Should navigate to set goal page correctly", () async {
      sut.goToSetGoalPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.setGoal),
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

      loadSaleStatistics.mockGetError();

      await sut.getSales(homePresenter);
    });

    test("Should update sale movements correctly", () async {
      await sut.getSales(homePresenter);

      expect(
        sut.saleStatistics,
        saleStatisticsEntities
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
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
      ).subtract(Duration(days: 1));

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: endDate,
              groupByDay: true,
              groupByEnterprise: true,
            ),
          )).called(1);
    });

    test("Should update last get sales params correctly when is daily",
        () async {
      await sut.getSales(
        homePresenter,
        forceRefresh: true,
        periodType: PeriodType.daily,
      );

      DateTime startDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        1,
      );

      DateTime endDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month + 1,
      ).subtract(Duration(days: 1));

      expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            groupByDay: true,
            groupByEnterprise: true,
          ));
    });
    test("Should update last get sales params correctly when is monthly",
        () async {
      await sut.getSales(
        homePresenter,
        forceRefresh: true,
        periodType: PeriodType.monthly,
      );

      expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: DateTime(
              homePresenter.selectedDateMock.year,
              homePresenter.selectedDateMock.month,
              1,
            ),
            endDate: DateTime(
              homePresenter.selectedDateMock.year,
              homePresenter.selectedDateMock.month + 1,
            ).subtract(Duration(days: 1)),
            groupByDay: true,
            groupByEnterprise: true,
          ));
    });

    test("Should not load sales again if dont change the month", () async {
      await sut.getSales(homePresenter, periodType: PeriodType.monthly);
      await sut.getSales(homePresenter, periodType: PeriodType.monthly);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
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
              groupByDay: true,
              groupByEnterprise: true,
            ),
          )).called(1);
    });
    test("Should load sales again if force refresh", () async {
      homePresenter.selectedDateMock = faker.date.dateTime();
      await sut.getSales(homePresenter);
      await sut.getSales(homePresenter, forceRefresh: true);

      DateTime startDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        1,
      );

      DateTime endDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month + 1,
      ).subtract(Duration(days: 1));

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: endDate,
              groupByDay: true,
              groupByEnterprise: true,
            ),
          )).called(2);
    });

    group("Get compare days statistics", () {
      test("Should call current day get sales with correct values", () async {
        await sut.getSales(homePresenter);

        verify(() => loadSaleStatistics.get(
              GetSaleStatisticsParams(
                startDate: DateTime(
                  homePresenter.selectedDateMock.year,
                  homePresenter.selectedDateMock.month,
                  homePresenter.selectedDateMock.day,
                ),
                endDate: DateTime(
                  homePresenter.selectedDateMock.year,
                  homePresenter.selectedDateMock.month,
                  homePresenter.selectedDateMock.day,
                ),
                groupByHour: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });
      test("Should call previous month day get sales with correct values",
          () async {
        await sut.getSales(homePresenter);

        verify(() => loadSaleStatistics.get(
              GetSaleStatisticsParams(
                startDate: DateTime(
                  homePresenter.selectedDateMock.year,
                  homePresenter.selectedDateMock.month - 1,
                  homePresenter.selectedDateMock.day,
                ),
                endDate: DateTime(
                  homePresenter.selectedDateMock.year,
                  homePresenter.selectedDateMock.month - 1,
                  homePresenter.selectedDateMock.day,
                ),
                groupByHour: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });

      test("Should update compare sales statistics correctly", () async {
        await sut.getSales(homePresenter);

        expect(sut.compareDaysStatistics, [
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
        ]);
      });
    });
  });
}

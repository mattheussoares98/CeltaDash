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
  late GetxPaymentTypePresenter sut;
  late HomePresenterSpy homePresenter;

  late EcLoadSaleStatisticsSpy ecLoadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticEntities;
  late EcEnterpriseEntity selectedEnterprise;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    ecLoadSaleStatistics = EcLoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxPaymentTypePresenter(
      ecLoadSaleStatistics: ecLoadSaleStatistics,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleStatisticEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
    selectedEnterprise = EntityFactory.makeEcEnterpriseEntity();
  }

  void initMockSuccess() {
    ecLoadSaleStatistics.mockGet(saleStatisticEntities);
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

  group("Get sales", () {
    group("Pattern requests", () {
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

        ecLoadSaleStatistics.mockGetError();

        await sut.getSales(homePresenter);
      });

      test("Should update period type correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        expect(sut.selectedPeriod, PeriodType.monthly);

        homePresenter.selectedDateMock =
            faker.date.dateTime(minYear: 10, maxYear: 20);
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        expect(sut.selectedPeriod, PeriodType.daily);

        homePresenter.selectedDateMock =
            faker.date.dateTime(minYear: 1, maxYear: 2);
        await sut.getSales(homePresenter, periodType: PeriodType.weekly);
        expect(sut.selectedPeriod, PeriodType.weekly);
      });
    });

    group("Sales movements by modality", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleStatistics,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should update last get sales params correctly", () async {
        homePresenter.selectedDateMock = faker.date.dateTime();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        expect(
          sut.lastGetStatisticsParams,
          GetEcSaleStatisticsParams(
            startDate: startDate,
            endDate: startDate,
            groupByEnterprise: true,
            groupByDay: true,
            groupByPaymentFinalization: true,
          ),
        );
      });

      test(
          "Should load sale movements with correct values when period type is daily",
          () async {
        homePresenter.selectedEnterpriseMock =
            EcEnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                startDate: startDate,
                endDate: startDate,
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentModality: true,
              ),
            )).called(1);
      });
      test(
          "Should load sale movements with correct values when period type is monthly",
          () async {
        homePresenter.selectedEnterpriseMock =
            EcEnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                startDate: startDate,
                endDate: endDate,
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentModality: true,
              ),
            )).called(1);
      });

      test(
          "Should not load sale movements if dont change the month and is monthly period",
          () async {
        homePresenter.selectedDateMock = faker.date.dateTime();

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        homePresenter.selectedDateMock = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          faker.randomGenerator.integer(28),
        );
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentModality: true,
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
              ),
            )).called(1);
      });
      test(
          "Should load sale movements if dont change the month but force refresh",
          () async {
        homePresenter.selectedDateMock = faker.date.dateTime();

        await sut.getSales(homePresenter);
        await sut.getSales(homePresenter, forceRefresh: true);

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentModality: true,
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
              ),
            )).called(2);
      });

      test(
          "Should not load daily if already load monthly and is not forcing refresh",
          () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        verifyNever(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                startDate: startDate,
                endDate: startDate,
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentModality: true,
              ),
            ));
      });
      test("Should update selected period correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        expect(sut.selectedPeriod, PeriodType.monthly);

        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        expect(sut.selectedPeriod, PeriodType.daily);
      });
    });

    group("Sales movements by finalizations", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleStatisticsByFinalizations,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load sale movements with correct values if period is daily",
          () async {
        homePresenter.selectedEnterpriseMock =
            EcEnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                startDate: startDate,
                endDate: startDate,
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentFinalization: true,
              ),
            )).called(1);
      });
      test("Should load sale movements with correct date if period is monthly",
          () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                startDate: startDate,
                endDate: endDate,
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentFinalization: true,
              ),
            )).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => ecLoadSaleStatistics.get(
              GetEcSaleStatisticsParams(
                startDate: startDate,
                endDate: endDate,
                groupByEnterprise: true,
                groupByDay: true,
                groupByPaymentFinalization: true,
              ),
            )).called(1);
      });
    });
  });
}

import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:celta_dash/ui/services/services.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../services/services.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxPersonalizedPresenter sut;
  late HomePresenterSpy homePresenter;

  late AppAnalyticsServiceSpy appAnalyticsService;

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticsEntities;
  late DateTime startDate;
  late DateTime endDate;
  late List<int> enterpriseIds;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    Get.put<HomePresenter>(homePresenter);

    sut = GetxPersonalizedPresenter(
      loadSaleStatistics: loadSaleStatistics,
    );
  }

  void initEntities() {
    saleStatisticsEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
    startDate = faker.date.dateTime();
    endDate = faker.date.dateTime(minYear: startDate.year + 1);
    enterpriseIds = [
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(100),
    ];
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticsEntities);
  }

  void initServices() {
    appAnalyticsService = AppAnalyticsServiceSpy();
    Get.put<AppAnalyticsService>(appAnalyticsService);
  }

  setUp(() {
    initServices();
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetSalesParams());
    for (var key in ReportType.values) {
      registerFallbackValue(key);
    }
    for (var key in PeriodType.values) {
      registerFallbackValue(key);
    }
  });

  tearDown(() {
    Get.reset();
  });

  group("Get sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      sut.changeDateRange(startDate, endDate);

      await sut.getSales();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      sut.changeDateRange(startDate, endDate);
      loadSaleStatistics.mockGetError();

      await sut.getSales();
    });
    test("Should emit correct values when didnt date range", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.selectPeriod]),
      );

      await sut.getSales();
    });
    test("Should update sale statistics with correctly", () async {
      sut.changeDateRange(startDate, endDate);
      await sut.getSales();

      expect(
          sut.saleStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList());
    });

    test("Should call loadSaleStatistics with correct period", () async {
      sut.changeDateRange(startDate, endDate);

      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [],
            groupByEnterprise: true, //TODO fix
            groupByYear: false,
            groupByMonth: false,
            groupByDay: false,
            groupByHour: false,
            groupByProduct: false,
            groupByProductDepartment: false,
            groupByProductSection: false,
            groupByPaymentFinalization: false,
            groupByPaymentModality: false,
            groupByCashierOperator: false,
            groupBySeller: false,
            // topCount: false,
          ),
        ),
      ).called(1);
    });
    test("Should call loadSaleStatistics with correct enterprise ids",
        () async {
      sut.changeDateRange(startDate, endDate);
      for (var id in enterpriseIds) {
        sut.changeEnterpriseIds(id);
      }
      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: enterpriseIds,
            groupByEnterprise: true, //TODO fix
            groupByYear: false,
            groupByMonth: false,
            groupByDay: false,
            groupByHour: false,
            groupByProduct: false,
            groupByProductDepartment: false,
            groupByProductSection: false,
            groupByPaymentFinalization: false,
            groupByPaymentModality: false,
            groupByCashierOperator: false,
            groupBySeller: false,
            // topCount: false,
          ),
        ),
      ).called(1);
    });
    test("Should call loadSaleStatistics with correct non category groupings",
        () async {
      sut.changeDateRange(startDate, endDate);

      final periodSelected = PeriodGroupingType.values[
          faker.randomGenerator.integer(PeriodGroupingType.values.length)];
      sut.changePeriodGroupingType(periodSelected);

      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [],
            groupByEnterprise: true, //TODO fix test
            groupByYear: sut.periodGroupingType == PeriodGroupingType.year,
            groupByMonth: sut.periodGroupingType == PeriodGroupingType.month,
            groupByDay: sut.periodGroupingType == PeriodGroupingType.day,
            groupByHour: sut.periodGroupingType == PeriodGroupingType.hour,
            groupByProduct: false,
            groupByProductDepartment: false,
            groupByProductSection: false,
            groupByPaymentFinalization: false,
            groupByPaymentModality: false,
            groupByCashierOperator: false,
            groupBySeller: false,
            // topCount: false,
          ),
        ),
      ).called(1);
    });
    test("Should call loadSaleStatistics with correct category groupings",
        () async {
      sut.changeDateRange(startDate, endDate);

      final categorySelected = CategoryGroupingType.values[
          faker.randomGenerator.integer(CategoryGroupingType.values.length)];
      sut.changeCategoryGroupingType(categorySelected);

      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [],
            groupByEnterprise: true, //TODO remove after fix
            groupByYear: false,
            groupByMonth: false,
            groupByDay: false,
            groupByHour: false,
            groupByProduct:
                sut.categoryGroupingType == CategoryGroupingType.product,
            groupByProductDepartment: sut.categoryGroupingType ==
                CategoryGroupingType.productDepartment,
            groupByProductSection:
                sut.categoryGroupingType == CategoryGroupingType.productSection,
            groupByPaymentFinalization: sut.categoryGroupingType ==
                CategoryGroupingType.paymentFinalization,
            groupByPaymentModality: sut.categoryGroupingType ==
                CategoryGroupingType.paymentModality,
            groupByCashierOperator: sut.categoryGroupingType ==
                CategoryGroupingType.cashierOperator,
            groupBySeller:
                sut.categoryGroupingType == CategoryGroupingType.seller,
            // topCount: false,
          ),
        ),
      ).called(1);
    });

    test("Should add new app monthly analytics", () async {
      sut.changeDateRange(startDate, endDate);

      await sut.getSales();

      verify(
        () => appAnalyticsService.addNewMonthlyAnalytic(
          reportType: ReportType.personalized,
          periodType: PeriodType.personalized,
        ),
      ).called(1);
    });
  });

  group("Change selected date range", () {
    test("Should update selected date range", () async {
      sut.changeDateRange(startDate, endDate);

      expect(sut.startDate, startDate);
      expect(sut.endDate, endDate);
    });
  });

  group("Change selected enterprise", () {
    test("Should update correctly", () {
      final enterpriseId1 = faker.randomGenerator.integer(100);
      final enterpriseId2 = faker.randomGenerator.integer(200, min: 101);

      sut.changeEnterpriseIds(enterpriseId1);
      expect(sut.enterprisesIds, [enterpriseId1]);

      sut.changeEnterpriseIds(enterpriseId2);
      expect(sut.enterprisesIds, [enterpriseId1, enterpriseId2]);

      sut.changeEnterpriseIds(enterpriseId2);
      expect(sut.enterprisesIds, [enterpriseId1]);

      sut.changeEnterpriseIds(enterpriseId1);
      expect(sut.enterprisesIds, []);
    });
  });

  group("Change selected grouping type", () {
    test("Should update correctly", () {
      const operator = CategoryGroupingType.cashierOperator;
      const product = CategoryGroupingType.product;

      sut.changeCategoryGroupingType(operator);
      expect(sut.categoryGroupingType, operator);

      sut.changeCategoryGroupingType(product);
      expect(sut.categoryGroupingType, product);

      sut.changeCategoryGroupingType(product);
      expect(sut.categoryGroupingType, null);
    });
  });

  group("Change non category grouping type", () {
    test("Should update correctly", () {
      const day = PeriodGroupingType.day;
      const month = PeriodGroupingType.month;

      sut.changePeriodGroupingType(day);
      expect(sut.periodGroupingType, day);

      sut.changePeriodGroupingType(month);
      expect(sut.periodGroupingType, month);

      sut.changePeriodGroupingType(month);
      expect(sut.periodGroupingType, null);
    });
  });

  group("Select all enterprises", () {
    test("Should select all enterprises", () {
      sut.selectAllEnterprises();
      sut.selectAllEnterprises();
      sut.selectAllEnterprises();

      expect(
        sut.enterprisesIds,
        homePresenter.enterprisesMock!.map((e) => e.id!.toInt()).toList(),
      );
    });
  });
}

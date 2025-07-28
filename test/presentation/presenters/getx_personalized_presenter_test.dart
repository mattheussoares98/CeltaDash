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
  late int enterpriseId;

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
    enterpriseId = faker.randomGenerator.integer(100);
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
    test("Should emit correct values on select LARGE interval to group by hour",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream,
          emitsInOrder(
            [null, UIError.custom(R.string.msgLongIntervalToGroupThisPeriod)],
          ));

      sut.changeDateRange(startDate, startDate.add(const Duration(days: 4)));
      sut.changeSelectedEnterprise(enterpriseId);
      sut.changePeriodGroupingType(PeriodGroupingType.hour);

      await sut.getSales();
    });
    test("Should emit correct values on select LARGE interval to group by day",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream,
          emitsInOrder(
            [null, UIError.custom(R.string.msgLongIntervalToGroupThisPeriod)],
          ));

      sut.changeDateRange(startDate, startDate.add(const Duration(days: 61)));
      sut.changeSelectedEnterprise(enterpriseId);
      sut.changePeriodGroupingType(PeriodGroupingType.day);

      await sut.getSales();
    });
    test(
        "Should emit error and return false when end date is before start date",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream,
          emitsInOrder(
            [null, UIError.custom(R.string.msgEndDateBeforeStartDate)],
          ));

      sut.changeDateRange(
          startDate, startDate.subtract(const Duration(days: 1)));
      sut.changeSelectedEnterprise(enterpriseId);
      sut.changePeriodGroupingType(PeriodGroupingType.day);

      expect(await sut.getSales(), false);
    });

    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);
      loadSaleStatistics.mockGetError();

      await sut.getSales();
    });
    test(
        "Should emit correct values when doesnt select at least one enterprise",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.selectEnterprise]),
      );

      sut.changeDateRange(startDate, endDate);

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
      sut.changeSelectedEnterprise(enterpriseId);
      await sut.getSales();

      expect(
          sut.saleStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList());
    });

    test("Should call loadSaleStatistics with correct period", () async {
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);

      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [enterpriseId],
          ),
        ),
      ).called(1);
    });
    test("Should call loadSaleStatistics with correct enterprise ids",
        () async {
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);
      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [enterpriseId],
          ),
        ),
      ).called(1);
    });

    test("Should call loadSaleStatistics with correct category groupings",
        () async {
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);

      final categorySelected = CategoryGroupingType.values[
          faker.randomGenerator.integer(CategoryGroupingType.values.length)];
      sut.changeCategoryGroupingType(categorySelected);

      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [enterpriseId],
            groupByProduct: categorySelected == CategoryGroupingType.product,
            groupByProductDepartment:
                categorySelected == CategoryGroupingType.productDepartment,
            groupByProductSection:
                categorySelected == CategoryGroupingType.productSection,
            groupByPaymentFinalization:
                categorySelected == CategoryGroupingType.paymentFinalization,
            groupByPaymentModality:
                categorySelected == CategoryGroupingType.paymentModality,
            groupByCashierOperator:
                categorySelected == CategoryGroupingType.cashierOperator,
            groupBySeller: categorySelected == CategoryGroupingType.seller,
            // topCount: false,
          ),
        ),
      ).called(1);
    });

    test("Should add new app monthly analytics", () async {
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);

      await sut.getSales();

      verify(
        () => appAnalyticsService.addNewMonthlyAnalytic(
          reportType: ReportType.personalized,
          periodType: PeriodType.personalized,
        ),
      ).called(1);
    });
    test("Should return true on success", () async {
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);

      final value = await sut.getSales();

      expect(value, true);
    });
    test("Should return false on error", () async {
      final value = await sut.getSales();

      expect(value, false);
    });

    test("Should not group by period when select product and return top 300",
        () async {
      //select date
      sut.changeDateRange(startDate, startDate);
      sut.changeSelectedEnterprise(enterpriseId);

      //select product
      sut.changeCategoryGroupingType(CategoryGroupingType.product);

      //select period
      final selectedPeriod = PeriodGroupingType.values[
          faker.randomGenerator.integer(PeriodGroupingType.values.length)];
      sut.changePeriodGroupingType(selectedPeriod);

      await sut.getSales();

      expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: startDate,
            enterpriseIds: [enterpriseId],
            groupByYear: false,
            groupByMonth: false,
            groupByDay: false,
            groupByHour: false,
            groupByProduct: true,
            groupByProductDepartment: false,
            groupByProductSection: false,
            groupByPaymentFinalization: false,
            groupByPaymentModality: false,
            groupByCashierOperator: false,
            groupBySeller: false,
            topCount: 300,
          ));
    });
    test("Should not group by period when select product section", () async {
      //select date
      sut.changeDateRange(startDate, startDate);
      sut.changeSelectedEnterprise(enterpriseId);

      //select productSection
      sut.changeCategoryGroupingType(CategoryGroupingType.productSection);

      //select period
      final selectedPeriod = PeriodGroupingType.values[
          faker.randomGenerator.integer(PeriodGroupingType.values.length)];
      sut.changePeriodGroupingType(selectedPeriod);

      await sut.getSales();

      expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: startDate,
            enterpriseIds: [enterpriseId],
            groupByYear: false,
            groupByMonth: false,
            groupByDay: false,
            groupByHour: false,
            groupByProduct: false,
            groupByProductDepartment: false,
            groupByProductSection: true,
            groupByPaymentFinalization: false,
            groupByPaymentModality: false,
            groupByCashierOperator: false,
            groupBySeller: false,
          ));
    });
    test("Should not group by period when select product department", () async {
      //select date
      sut.changeDateRange(startDate, startDate);
      sut.changeSelectedEnterprise(enterpriseId);

      //select productDepartment
      sut.changeCategoryGroupingType(CategoryGroupingType.productDepartment);

      //select period
      final selectedPeriod = PeriodGroupingType.values[
          faker.randomGenerator.integer(PeriodGroupingType.values.length)];
      sut.changePeriodGroupingType(selectedPeriod);

      await sut.getSales();

      expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: startDate,
            enterpriseIds: [enterpriseId],
            groupByYear: false,
            groupByMonth: false,
            groupByDay: false,
            groupByHour: false,
            groupByProduct: false,
            groupByProductDepartment: true,
            groupByProductSection: false,
            groupByPaymentFinalization: false,
            groupByPaymentModality: false,
            groupByCashierOperator: false,
            groupBySeller: false,
          ));
    });
  });

  group("Change selected date range", () {
    test('Should update correctly if pass non null values', () {
      expect(sut.startDate, isNull);
      expect(sut.endDate, isNull);

      sut.changeDateRange(startDate, endDate);

      expect(sut.startDate, isNotNull);
      expect(sut.endDate, isNotNull);
      expect(
        sut.currentSelectedParams,
        GetSaleStatisticsParams(startDate: startDate, endDate: endDate),
      );
    });
    test('Should NOT update start date and end date if pass null values', () {
      sut.changeDateRange(null, null);

      expect(sut.startDate, isNull);
      expect(sut.endDate, isNull);
    });
  });

  group("Change selected enterprise", () {
    test("Should update correctly", () {
      final enterpriseId1 = faker.randomGenerator.integer(100);
      final enterpriseId2 = faker.randomGenerator.integer(200, min: 101);

      sut.changeDateRange(startDate, endDate);

      sut.changeSelectedEnterprise(enterpriseId1);
      expect(sut.currentSelectedParams?.enterpriseIds, [enterpriseId1]);

      sut.changeSelectedEnterprise(enterpriseId2);
      expect(sut.currentSelectedParams?.enterpriseIds, [enterpriseId2]);

      sut.changeSelectedEnterprise(enterpriseId2);
      expect(sut.currentSelectedParams?.enterpriseIds, [enterpriseId2]);

      sut.changeSelectedEnterprise(enterpriseId1);
      expect(sut.currentSelectedParams?.enterpriseIds, [enterpriseId1]);
    });
  });

  group("Change selected grouping type", () {
    test("Should update correctly", () {
      const cashierOperator = CategoryGroupingType.cashierOperator;
      const paymentFinalization = CategoryGroupingType.paymentFinalization;
      const paymentModality = CategoryGroupingType.paymentModality;
      const product = CategoryGroupingType.product;
      const productDepartment = CategoryGroupingType.productDepartment;
      const productSection = CategoryGroupingType.productSection;
      const seller = CategoryGroupingType.seller;

      sut.changeDateRange(startDate, endDate);

      //departments and sections
      sut.changeCategoryGroupingType(productDepartment);
      expect(sut.currentSelectedParams?.groupByProductDepartment, true);

      sut.changeCategoryGroupingType(productSection);
      expect(sut.currentSelectedParams?.groupByProductDepartment, true);
      expect(sut.currentSelectedParams?.groupByProductSection, true);

      sut.changeCategoryGroupingType(productDepartment);
      expect(sut.currentSelectedParams?.groupByProductDepartment, false);
      expect(sut.currentSelectedParams?.groupByProductSection, true);

      //finalizations
      sut.changeCategoryGroupingType(paymentFinalization);
      expect(sut.currentSelectedParams?.groupByPaymentFinalization, true);

      sut.changeCategoryGroupingType(paymentModality);
      expect(sut.currentSelectedParams?.groupByPaymentFinalization, true);
      expect(sut.currentSelectedParams?.groupByPaymentModality, true);

      sut.changeCategoryGroupingType(paymentFinalization);
      expect(sut.currentSelectedParams?.groupByPaymentFinalization, false);
      expect(sut.currentSelectedParams?.groupByPaymentModality, true);

      //anothers
      sut.changeCategoryGroupingType(cashierOperator);
      expect(sut.currentSelectedParams?.groupByCashierOperator, true);
      sut.changeCategoryGroupingType(cashierOperator);
      expect(sut.currentSelectedParams?.groupByCashierOperator, false);

      sut.changeCategoryGroupingType(product);
      expect(sut.currentSelectedParams?.groupByProduct, true);
      sut.changeCategoryGroupingType(product);
      expect(sut.currentSelectedParams?.groupByProduct, false);

      sut.changeCategoryGroupingType(seller);
      expect(sut.currentSelectedParams?.groupBySeller, true);
      sut.changeCategoryGroupingType(seller);
      expect(sut.currentSelectedParams?.groupBySeller, false);
    });
  });

  group("Change period grouping type", () {
    test("Should update correctly", () {
      sut.changeDateRange(startDate, endDate);

      sut.changePeriodGroupingType(PeriodGroupingType.hour);
      sut.changePeriodGroupingType(PeriodGroupingType.hour);
      expect(sut.currentSelectedParams?.groupByYear, false);
      expect(sut.currentSelectedParams?.groupByMonth, false);
      expect(sut.currentSelectedParams?.groupByDay, false);
      expect(sut.currentSelectedParams?.groupByHour, true);

      sut.changePeriodGroupingType(PeriodGroupingType.day);
      sut.changePeriodGroupingType(PeriodGroupingType.day);
      expect(sut.currentSelectedParams?.groupByYear, false);
      expect(sut.currentSelectedParams?.groupByMonth, false);
      expect(sut.currentSelectedParams?.groupByDay, true);
      expect(sut.currentSelectedParams?.groupByHour, false);

      sut.changePeriodGroupingType(PeriodGroupingType.month);
      sut.changePeriodGroupingType(PeriodGroupingType.month);
      expect(sut.currentSelectedParams?.groupByYear, false);
      expect(sut.currentSelectedParams?.groupByMonth, true);
      expect(sut.currentSelectedParams?.groupByDay, false);
      expect(sut.currentSelectedParams?.groupByHour, false);

      sut.changePeriodGroupingType(PeriodGroupingType.year);
      sut.changePeriodGroupingType(PeriodGroupingType.year);
      expect(sut.currentSelectedParams?.groupByYear, true);
      expect(sut.currentSelectedParams?.groupByMonth, false);
      expect(sut.currentSelectedParams?.groupByDay, false);
      expect(sut.currentSelectedParams?.groupByHour, false);
    });
  });
}

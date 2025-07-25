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
    test("Should emit correct values on select SHORT interval to group by year",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream,
          emitsInOrder(
            [null, UIError.custom(R.string.msgShortIntervalToGroupThisPeriod)],
          ));

      sut.changeDateRange(startDate, startDate.add(const Duration(days: 365)));
      sut.changeSelectedEnterprise(enterpriseId);
      sut.changePeriodGroupingType(PeriodGroupingType.year);

      await sut.getSales();
    });
    test(
        "Should emit correct values on select SHORT interval to group by month",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream,
          emitsInOrder(
            [null, UIError.custom(R.string.msgShortIntervalToGroupThisPeriod)],
          ));

      sut.changeDateRange(startDate, startDate.add(const Duration(days: 31)));
      sut.changeSelectedEnterprise(enterpriseId);
      sut.changePeriodGroupingType(PeriodGroupingType.month);

      await sut.getSales();
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
    test("Should call loadSaleStatistics with correct non category groupings",
        () async {
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);

      final periodSelected = PeriodGroupingType.values[
          faker.randomGenerator.integer(PeriodGroupingType.values.length)];
      sut.changePeriodGroupingType(periodSelected);

      await sut.getSales();

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            groupByYear: periodSelected == PeriodGroupingType.year,
            groupByMonth: periodSelected == PeriodGroupingType.month,
            groupByDay: periodSelected == PeriodGroupingType.day,
            groupByHour: periodSelected == PeriodGroupingType.hour,
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

    test("Should update last get sale statistics params correctly", () async {
      //select date
      sut.changeDateRange(startDate, endDate);
      sut.changeSelectedEnterprise(enterpriseId);

      //select category
      final selectedCategory = CategoryGroupingType.values[
          faker.randomGenerator.integer(CategoryGroupingType.values.length)];
      sut.changeCategoryGroupingType(selectedCategory);

      //select period
      final selectedPeriod = PeriodGroupingType.values[
          faker.randomGenerator.integer(PeriodGroupingType.values.length)];
      sut.changePeriodGroupingType(selectedPeriod);

      await sut.getSales();

      expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: endDate,
            enterpriseIds: [enterpriseId],
            groupByYear: selectedPeriod == PeriodGroupingType.year,
            groupByMonth: selectedPeriod == PeriodGroupingType.month,
            groupByDay: selectedPeriod == PeriodGroupingType.day,
            groupByHour: selectedPeriod == PeriodGroupingType.hour,
            groupByProduct: selectedCategory == CategoryGroupingType.product,
            groupByProductDepartment:
                selectedCategory == CategoryGroupingType.productDepartment,
            groupByProductSection:
                selectedCategory == CategoryGroupingType.productSection,
            groupByPaymentFinalization:
                selectedCategory == CategoryGroupingType.paymentFinalization,
            groupByPaymentModality:
                selectedCategory == CategoryGroupingType.paymentModality,
            groupByCashierOperator:
                selectedCategory == CategoryGroupingType.cashierOperator,
            groupBySeller: selectedCategory == CategoryGroupingType.seller,
            // topCount: false,
          ));
    });
    test("Should not group by period when select product and return top 300",
        () async {
      //select date
      sut.changeDateRange(startDate, endDate);
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
            endDate: endDate,
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
  });

  group("Change selected date range", () {
    test("Should update selected date range", () async {
      sut.changeDateRange(startDate, endDate);

      expect(
        sut.currentSelectedParams,
        GetSaleStatisticsParams(startDate: startDate, endDate: endDate),
      );
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

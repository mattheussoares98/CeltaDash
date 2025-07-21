import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/services/services.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../services/services.dart';

void main() {
  late GetxPersonalizedPresenter sut;

  late AppAnalyticsServiceSpy appAnalyticsService;

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticsEntities;
  late DateTime startDate;
  late DateTime endDate;
  late List<int>? enterpriseIds;
  late bool? groupByEnterprise;
  late bool? groupByYear;
  late bool? groupByMonth;
  late bool? groupByDay;
  late bool? groupByHour;
  late bool? groupByProduct;
  late bool? groupByProductDepartment;
  late bool? groupByProductSection;
  late bool? groupByPaymentFinalization;
  late bool? groupByPaymentModality;
  late bool? groupByCashierOperator;
  late bool? groupBySeller;
  late int? topCount;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
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
      faker.randomGenerator.integer(10),
      faker.randomGenerator.integer(10),
      faker.randomGenerator.integer(10),
    ];
    groupByEnterprise = faker.randomGenerator.boolean();
    groupByYear = faker.randomGenerator.boolean();
    groupByMonth = faker.randomGenerator.boolean();
    groupByDay = faker.randomGenerator.boolean();
    groupByHour = faker.randomGenerator.boolean();
    groupByProduct = faker.randomGenerator.boolean();
    groupByProductDepartment = faker.randomGenerator.boolean();
    groupByProductSection = faker.randomGenerator.boolean();
    groupByPaymentFinalization = faker.randomGenerator.boolean();
    groupByPaymentModality = faker.randomGenerator.boolean();
    groupByCashierOperator = faker.randomGenerator.boolean();
    groupBySeller = faker.randomGenerator.boolean();
    topCount = faker.randomGenerator.integer(200);
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

      await sut.getSales(
        startDate: startDate,
        endDate: endDate,
        enterpriseIds: enterpriseIds,
        groupByEnterprise: groupByEnterprise,
        groupByYear: groupByYear,
        groupByMonth: groupByMonth,
        groupByDay: groupByDay,
        groupByHour: groupByHour,
        groupByProduct: groupByProduct,
        groupByProductDepartment: groupByProductDepartment,
        groupByProductSection: groupByProductSection,
        groupByPaymentFinalization: groupByPaymentFinalization,
        groupByPaymentModality: groupByPaymentModality,
        groupByCashierOperator: groupByCashierOperator,
        groupBySeller: groupBySeller,
        topCount: topCount,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleStatistics.mockGetError();

      await sut.getSales(
        startDate: startDate,
        endDate: endDate,
        enterpriseIds: enterpriseIds,
        groupByEnterprise: groupByEnterprise,
        groupByYear: groupByYear,
        groupByMonth: groupByMonth,
        groupByDay: groupByDay,
        groupByHour: groupByHour,
        groupByProduct: groupByProduct,
        groupByProductDepartment: groupByProductDepartment,
        groupByProductSection: groupByProductSection,
        groupByPaymentFinalization: groupByPaymentFinalization,
        groupByPaymentModality: groupByPaymentModality,
        groupByCashierOperator: groupByCashierOperator,
        groupBySeller: groupBySeller,
        topCount: topCount,
      );
    });
    test("Should update sale statistics with correctly", () async {
      await sut.getSales(
        startDate: startDate,
        endDate: endDate,
        enterpriseIds: enterpriseIds,
        groupByEnterprise: groupByEnterprise,
        groupByYear: groupByYear,
        groupByMonth: groupByMonth,
        groupByDay: groupByDay,
        groupByHour: groupByHour,
        groupByProduct: groupByProduct,
        groupByProductDepartment: groupByProductDepartment,
        groupByProductSection: groupByProductSection,
        groupByPaymentFinalization: groupByPaymentFinalization,
        groupByPaymentModality: groupByPaymentModality,
        groupByCashierOperator: groupByCashierOperator,
        groupBySeller: groupBySeller,
        topCount: topCount,
      );

      expect(
          sut.saleStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList());
    });
  });

  group("Change selected date range", () {
    test("Should update selected date range", () async {
      sut.changeSelectedDateRange(startDate, endDate);

      expect(sut.startDate, startDate);
      expect(sut.endDate, endDate);
    });
  });
}

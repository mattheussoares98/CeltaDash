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
  late GetxCompareMonthsPresenter sut;

  late HomePresenterSpy homePresenter;

  late AppAnalyticsServiceSpy appAnalyticsService;

  late LoadSaleStatisticsSpy loadSaleStatistics;
  late List<SaleStatisticsEntity> saleStatisticsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxCompareMonthsPresenter(
      loadSaleStatistics: loadSaleStatistics,
    );
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
  }

  void initServices() {
    appAnalyticsService = AppAnalyticsServiceSpy();
    Get.put<AppAnalyticsService>(appAnalyticsService);
    homePresenter = HomePresenterSpy();
    Get.put<HomePresenter>(homePresenter);
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
    registerFallbackValue(EntityFactory.makeGetSaleMovementParams());
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

  test("Should change the years and months correctly", () {
    final now = DateTime.now();
    expect(sut.firstSelectedMonth, now.month - 1);
    expect(sut.firstSelectedYear, now.year);
    expect(sut.secondSelectedMonth, now.month);
    expect(sut.secondSelectedYear, now.year);

    final firstSelectedMonth = faker.randomGenerator.integer(12, min: 1);
    final firstSelectedYear = faker.randomGenerator.integer(2025, min: 2000);
    final secondSelectedMonth = faker.randomGenerator.integer(12, min: 1);
    final secondSelectedYear = faker.randomGenerator.integer(2025, min: 2000);
    sut.changeFirstSelectedMonth(firstSelectedMonth);
    sut.changeFirstSelectedYear(firstSelectedYear);
    sut.changeSecondSelectedMonth(secondSelectedMonth);
    sut.changeSecondSelectedYear(secondSelectedYear);

    expect(sut.firstSelectedMonth, firstSelectedMonth);
    expect(sut.firstSelectedYear, firstSelectedYear);
    expect(sut.secondSelectedMonth, secondSelectedMonth);
    expect(sut.secondSelectedYear, secondSelectedYear);
  });

  group("Get sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getSales();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleStatistics.mockGetError();

      await sut.getSales();
    });
    test(
        "Should call first month with correct parameters and change first sales month",
        () async {
      final firstYear = faker.randomGenerator.integer(2025, min: 2000);
      final firstMonth = faker.randomGenerator.integer(12, min: 1);
      sut.changeFirstSelectedYear(firstYear);
      sut.changeFirstSelectedMonth(firstMonth);

      await sut.getSales();

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              groupByDay: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(firstYear, firstMonth, 1),
              endDate: DateTime(firstYear, firstMonth + 1, 0),
            ),
          )).called(1);

      expect(
          sut.firstMonthSales,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList());
    });
    test(
        "Should call second month with correct parameters and change second sales month",
        () async {
      final secondYear = faker.randomGenerator.integer(2025, min: 2000);
      final secondMonth = faker.randomGenerator.integer(12, min: 1);
      sut.changeSecondSelectedYear(secondYear);
      sut.changeSecondSelectedMonth(secondMonth);

      await sut.getSales();

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              groupByDay: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(secondYear, secondMonth, 1),
              endDate: DateTime(secondYear, secondMonth + 1, 0),
            ),
          )).called(1);

      expect(
          sut.secondMonthSales,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList());
    });

    test("Should emit error if try to compare the same period", () async {
      final year = faker.randomGenerator.integer(2025, min: 2000);
      final month = faker.randomGenerator.integer(12, min: 1);
      sut.changeFirstSelectedMonth(month);
      sut.changeFirstSelectedYear(year);
      sut.changeSecondSelectedMonth(month);
      sut.changeSecondSelectedYear(year);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.custom(R.string.msgSamePeriod)]),
      );

      await sut.getSales();
    });
  });
}

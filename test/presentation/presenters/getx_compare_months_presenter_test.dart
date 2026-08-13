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

  late int firstSelectedMonth;
  late int firstSelectedYear;
  late int secondSelectedMonth;
  late int secondSelectedYear;
  late DateTime now;

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
    now = DateTime.now();
    firstSelectedMonth = faker.randomGenerator.integer(12, min: 1);
    firstSelectedYear = faker.randomGenerator.integer(now.year, min: 1);
    secondSelectedMonth = faker.randomGenerator.integer(12, min: 1);
    secondSelectedYear = faker.randomGenerator.integer(now.year, min: 1);
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
    expect(sut.firstSelectedMonth, now.month - 1);
    expect(sut.firstSelectedYear, now.year);
    expect(sut.secondSelectedMonth, now.month);
    expect(sut.secondSelectedYear, now.year);

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

      await sut.getSales(true);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleStatistics.mockGetError();

      await sut.getSales(true);
    });
    test(
        "Should call first month with correct parameters and change first sales month",
        () async {
      sut.changeFirstSelectedYear(firstSelectedYear);
      sut.changeFirstSelectedMonth(firstSelectedMonth);

      await sut.getSales(true);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              groupByDay: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(firstSelectedYear, firstSelectedMonth),
              endDate: DateTime(firstSelectedYear, firstSelectedMonth + 1, 0),
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
      sut.changeSecondSelectedYear(secondSelectedYear);
      sut.changeSecondSelectedMonth(secondSelectedMonth);

      await sut.getSales(true);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              groupByDay: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(secondSelectedYear, secondSelectedMonth),
              endDate: DateTime(secondSelectedYear, secondSelectedMonth + 1, 0),
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

      await sut.getSales(true);
    });

    test("Should change last params correctly", () async {
      sut.changeFirstSelectedMonth(firstSelectedMonth);
      sut.changeFirstSelectedYear(firstSelectedYear);
      sut.changeSecondSelectedMonth(secondSelectedMonth);
      sut.changeSecondSelectedYear(secondSelectedYear);

      await sut.getSales(true);

      expect(
          sut.firstMonthParams,
          GetSaleStatisticsParams(
            groupByDay: true,
            groupByEnterprise: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            startDate: DateTime(
              firstSelectedYear,
              firstSelectedMonth,
            ),
            endDate: DateTime(
              firstSelectedYear,
              firstSelectedMonth + 1,
              0,
            ),
          ));

      expect(
          sut.secondMonthParams,
          GetSaleStatisticsParams(
            groupByDay: true,
            groupByEnterprise: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            startDate: DateTime(
              secondSelectedYear,
              secondSelectedMonth,
            ),
            endDate: DateTime(
              secondSelectedYear,
              secondSelectedMonth + 1,
              0,
            ),
          ));
    });

    test("Should not change last params if throw", () async {
      loadSaleStatistics.mockGetError();

      await sut.getSales(true);

      expect(sut.firstMonthParams, isNull);
      expect(sut.secondMonthParams, isNull);
    });

    test("Should emit error if first period is future", () async {
      sut.changeFirstSelectedMonth(now.month + 1);
      sut.changeFirstSelectedYear(now.year);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.custom(R.string.msgFutureMonth)]),
      );

      await sut.getSales(true);
    });
    test("Should emit error if second period is future", () async {
      sut.changeSecondSelectedMonth(now.month + 1);
      sut.changeSecondSelectedYear(now.year);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.custom(R.string.msgFutureMonth)]),
      );

      await sut.getSales(true);
    });

    test("Should not load again if is not forcing refresh", () async {
      await sut.getSales(false);
      await sut.getSales(false);

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            groupByDay: true,
            groupByEnterprise: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            startDate: DateTime(now.year, now.month),
            endDate: DateTime(now.year, now.month + 1, 0),
          ),
        ),
      ).called(1);
    });
    test("Should load again if is forcing refresh", () async {
      await sut.getSales(true);
      await sut.getSales(true);

      verify(
        () => loadSaleStatistics.get(
          GetSaleStatisticsParams(
            groupByDay: true,
            groupByEnterprise: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            startDate: DateTime(now.year, now.month),
            endDate: DateTime(now.year, now.month + 1, 0),
          ),
        ),
      ).called(2);
    });
  });
}

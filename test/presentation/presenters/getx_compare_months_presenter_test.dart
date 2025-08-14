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
  late DateTime? selectedDate;
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
    selectedDate = faker.date.dateTime();
    now = DateTime.now();
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

  group("Get sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getSales(now: now);
    });

    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleStatistics.mockGetError();

      await sut.getSales(now: now);
    });

    test("Should call with correct dates when doesnt select a date", () async {
      await sut.getSales(now: now);

      //selected month
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                now.year,
                now.month,
                1,
                now.hour,
              ),
              endDate: DateTime(
                now.year,
                now.month + 1,
                0,
                now.hour,
              ),
            ),
          )).called(1);

      //previous month
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                now.year,
                now.month - 1,
                1,
                now.hour,
              ),
              endDate: DateTime(
                now.year,
                now.month - 1,
                0,
                now.hour,
              ),
            ),
          )).called(1);

      //previous year
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                now.year - 1,
                now.month,
                1,
                now.hour,
              ),
              endDate: DateTime(
                now.year - 1,
                now.month - 1,
                0,
                now.hour,
              ),
            ),
          )).called(1);
    });
    test("Should call with correct dates when change the selectedDate",
        () async {
      await sut.getSales(now: now, selectedDate: selectedDate);

      //selected month
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                selectedDate!.year,
                selectedDate!.month,
                1,
                0,
              ),
              endDate: DateTime(
                selectedDate!.year,
                selectedDate!.month + 1,
                0,
                0,
              ),
            ),
          )).called(1);

      //previous month
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                selectedDate!.year,
                selectedDate!.month - 1,
                1,
                0,
              ),
              endDate: DateTime(
                selectedDate!.year,
                selectedDate!.month - 1,
                0,
                0,
              ),
            ),
          )).called(1);

      //previous year
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                selectedDate!.year - 1,
                selectedDate!.month,
                1,
                0,
              ),
              endDate: DateTime(
                selectedDate!.year - 1,
                selectedDate!.month - 1,
                0,
                0,
              ),
            ),
          )).called(1);
    });
    test("Should not call twice because is not forcing refresh", () async {
      await sut.getSales(now: now, selectedDate: selectedDate);
      await sut.getSales(now: now, selectedDate: selectedDate);

      //selected month
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                selectedDate!.year,
                selectedDate!.month,
                1,
                0,
              ),
              endDate: DateTime(
                selectedDate!.year,
                selectedDate!.month + 1,
                0,
                0,
              ),
            ),
          )).called(1);
    });
    test("Should call again if force refresh", () async {
      await sut.getSales(now: now, forceRefresh: true);
      await sut.getSales(now: now, forceRefresh: true);

      //selected month
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                now.year,
                now.month,
                1,
                now.hour,
              ),
              endDate: DateTime(
                now.year,
                now.month + 1,
                0,
                now.hour,
              ),
            ),
          )).called(2);
    });
    test("Should add new correct app analytics", () async {
      await sut.getSales(now: now);

      //selected month
      verify(() => appAnalyticsService.addNewMonthlyAnalytic(
            reportType: ReportType.compareMonths,
            periodType: PeriodType.monthly,
          )).called(1);
    });
    test("Should update merged sales correctly", () async {
      await sut.getSales(now: now);

      final sales = saleStatisticsEntities
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();
      expect(sut.mergedSales, {
        CompareMonthsPeriod.selectedMonth: sales,
        CompareMonthsPeriod.previousMonth: sales,
        CompareMonthsPeriod.previousYear: sales,
      });
    });
    test("Should update last params", () async {
      expect(sut.lastParams, isNull);

      await sut.getSales(now: now);

      expect(sut.lastParams, isNotNull);
    });

    test("Should call again if change the selected enterprise", () async {
      await sut.getSales(now: now);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                now.year,
                now.month,
                1,
                now.hour,
              ),
              endDate: DateTime(
                now.year,
                now.month + 1,
                0,
                now.hour,
              ),
            ),
          )).called(1);

      //!Changing enterprise
      homePresenter.selectedEnterpriseMock = EnterpriseModel.fromEntity(
        EntityFactory.makeEnterpriseEntity(
            id: faker.randomGenerator.integer(999, min: 101)),
      ).toViewModel();

      await sut.getSales(now: now);
      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: DateTime(
                now.year,
                now.month,
                1,
                now.hour,
              ),
              endDate: DateTime(
                now.year,
                now.month + 1,
                0,
                now.hour,
              ),
            ),
          )).called(1);
    });
  });
}

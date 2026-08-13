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
  late GetxSalesPresenter sut;
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
    sut = GetxSalesPresenter(
      loadSaleStatistics: loadSaleStatistics,
    );
  }

  void initEntities() {
    saleStatisticsEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
    homePresenter.selectedDateMock = faker.date.dateTime();
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticsEntities);
  }

  void initServices() {
    appAnalyticsService = AppAnalyticsServiceSpy();
    homePresenter = HomePresenterSpy();
    Get.put<HomePresenter>(homePresenter);
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
    registerFallbackValue(HomePresenterSpy());
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
    group("Pattern", () {
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
      test("Should update period type correctly", () async {
        await sut.getSales(periodType: PeriodType.daily);
        expect(sut.selectedPeriod, PeriodType.daily);

        await sut.getSales(periodType: PeriodType.monthly);
        expect(sut.selectedPeriod, PeriodType.monthly);

        await sut.getSales(periodType: PeriodType.yearly);
        expect(sut.selectedPeriod, PeriodType.yearly);
      });

      test("Should add new analysis", () async {
        final enabledPeriods = [
          PeriodType.hourly,
          PeriodType.daily,
          PeriodType.monthly,
          PeriodType.yearly
        ];
        final periodType = enabledPeriods[faker.randomGenerator.integer(4)];

        await sut.getSales(
          periodType: periodType,
          forceRefresh: true,
        );

        verify(
          () => appAnalyticsService.addNewMonthlyAnalytic(
              reportType: ReportType.sales, periodType: periodType),
        ).called(1);
      });
    });
    group("PeriodType.hourly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(periodType: PeriodType.hourly);

        expect(
          sut.hourlyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(periodType: PeriodType.hourly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        final params = GetSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
          startDate: startDate,
          endDate: startDate,
          groupByEnterprise: true,
          groupByHour: true,
          groupByDay: false,
          groupByMonth: false,
          groupByYear: false,
        );

        verify(
          () => loadSaleStatistics.get(params),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(periodType: PeriodType.hourly);
        await sut.getSales(periodType: PeriodType.hourly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByHour: true,
              groupByDay: false,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);
      });
      test("Should load again if change the enterprise", () async {
        await sut.getSales(periodType: PeriodType.hourly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByHour: true,
              groupByDay: false,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise = EnterpriseModel.fromEntity(
                EntityFactory.makeEnterpriseEntity(
                    id: homePresenter.selectedEnterpriseMock!.id!.toInt() + 1))
            .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(periodType: PeriodType.hourly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByHour: true,
              groupByDay: false,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(periodType: PeriodType.hourly);
        await sut.getSales(
          periodType: PeriodType.hourly,
          forceRefresh: true,
        );

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByHour: true,
              groupByDay: false,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(periodType: PeriodType.hourly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        expect(
            sut.lastGetHourlyParams,
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByHour: true,
              groupByDay: false,
              groupByMonth: false,
              groupByYear: false,
            ));
      });
    });

    group("PeriodType.daily", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales();

        expect(
          sut.dailyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(periodType: PeriodType.daily);
        await sut.getSales(periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);
      });
      test("Should load again if change the enterprise", () async {
        await sut.getSales(periodType: PeriodType.daily);
        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(periodType: PeriodType.daily);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(periodType: PeriodType.daily);
        await sut.getSales(
          periodType: PeriodType.daily,
          forceRefresh: true,
        );

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        expect(
            sut.lastGetDailyParams,
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
            ));
      });
    });
    group("PeriodType.monthly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(periodType: PeriodType.monthly);

        expect(
          sut.monthlyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(periodType: PeriodType.monthly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(periodType: PeriodType.monthly);
        await sut.getSales(periodType: PeriodType.monthly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });

      test("Should load again if change the enterprise", () async {
        await sut.getSales(periodType: PeriodType.monthly);
        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise = EnterpriseModel.fromEntity(
                EntityFactory.makeEnterpriseEntity(
                    id: faker.randomGenerator.integer(999, min: 200)))
            .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(periodType: PeriodType.monthly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(periodType: PeriodType.monthly);
        await sut.getSales(
          periodType: PeriodType.monthly,
          forceRefresh: true,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(periodType: PeriodType.monthly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        expect(
            sut.lastGetMonthlyParams,
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: false,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
            ));
      });
    });
    group("PeriodType.yearly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(periodType: PeriodType.yearly);

        expect(
          sut.yearlyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
              groupByMonth: false,
              groupByHour: false,
              groupByDay: false,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(periodType: PeriodType.yearly);
        await sut.getSales(periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
              groupByMonth: false,
              groupByHour: false,
              groupByDay: false,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(periodType: PeriodType.yearly);
        await sut.getSales(
          periodType: PeriodType.yearly,
          forceRefresh: true,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
              groupByMonth: false,
              groupByHour: false,
              groupByDay: false,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        expect(
            sut.lastGetYearlyParams,
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
              groupByMonth: false,
              groupByHour: false,
              groupByDay: false,
            ));
      });

      test("Should load again if change the enterprise", () async {
        await sut.getSales(periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
              groupByMonth: false,
              groupByHour: false,
              groupByDay: false,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(periodType: PeriodType.yearly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
              groupByMonth: false,
              groupByHour: false,
              groupByDay: false,
            ),
          ),
        ).called(1);
      });
    });
  });
}

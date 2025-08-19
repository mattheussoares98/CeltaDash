import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
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
import '../mocks/mocks.dart';

void main() {
  late GetxResumePresenter sut;
  late HomePresenterSpy homePresenter;

  late AppAnalyticsServiceSpy appAnalyticsService;

  late NavigateToSpy navigateTo;
  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticsEntities;
  late DateTime now;

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
    now = DateTime.now();
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticsEntities);
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
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

      await sut.getSales(now: now, homePresenter);
    });

    test("Should emit correct values on error", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      loadSaleStatistics.mockGetError();

      await sut.getSales(now: now, homePresenter);
    });

    test("Should update sale movements correctly", () async {
      await sut.getSales(now: now, homePresenter);

      expect(
        sut.saleStatistics,
        saleStatisticsEntities
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });

    test("Should load sale movements with correct values", () async {
      await sut.getSales(now: now, homePresenter);

      DateTime startDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        1,
      );

      DateTime endDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month + 1,
      ).subtract(const Duration(days: 1));

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
        now: now,
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
      ).subtract(const Duration(days: 1));

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
        now: now,
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
            ).subtract(const Duration(days: 1)),
            groupByDay: true,
            groupByEnterprise: true,
          ));
    });

    test("Should not load sales again if dont change the month", () async {
      await sut.getSales(
          now: now, homePresenter, periodType: PeriodType.monthly);
      await sut.getSales(
          now: now, homePresenter, periodType: PeriodType.monthly);

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
              ).subtract(const Duration(days: 1)),
              groupByDay: true,
              groupByEnterprise: true,
            ),
          )).called(1);
    });
    test("Should load sales again if force refresh", () async {
      homePresenter.selectedDateMock = faker.date.dateTime();
      await sut.getSales(now: now, homePresenter);
      await sut.getSales(now: now, homePresenter, forceRefresh: true);

      DateTime startDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month,
        1,
      );

      DateTime endDate = DateTime(
        homePresenter.selectedDateMock.year,
        homePresenter.selectedDateMock.month + 1,
      ).subtract(const Duration(days: 1));

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
      test("Should update last get comparison sales params correctly",
          () async {
        await sut.getSales(now: now, homePresenter);

        expect(
            sut.lastGetDailyComparisonParams,
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
                23,
                59,
              ),
              groupByDay: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ));
      });
      test("Should call current day get sales with correct values", () async {
        await sut.getSales(now: now, homePresenter);

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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });
      test("Should call previous month day get sales with correct values",
          () async {
        await sut.getSales(now: now, homePresenter);

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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });

      test("Should update compare sales statistics correctly", () async {
        await sut.getSales(now: now, homePresenter);

        expect(sut.compareDaysStatistics, [
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
        ]);
      });
      test(
          "Should not call again if dont change the enterprise and is not forcing refresh",
          () async {
        await sut.getSales(now: now, homePresenter);
        await sut.getSales(now: now, homePresenter);

        //first date
        final firstParams = GetSaleStatisticsParams(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            homePresenter.selectedDateMock.day,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            homePresenter.selectedDateMock.day,
            23,
            59,
          ),
          groupByDay: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        );
        verify(() => loadSaleStatistics.get(firstParams)).called(1);

        //second date
        final secondParams = GetSaleStatisticsParams(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month - 1,
            homePresenter.selectedDateMock.day,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month - 1,
            homePresenter.selectedDateMock.day,
            23,
            59,
          ),
          groupByDay: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        );
        verify(() => loadSaleStatistics.get(secondParams)).called(1);
      });
      test("Should call again if is forcing refresh", () async {
        await sut.getSales(now: now, homePresenter);
        await sut.getSales(now: now, homePresenter, forceRefresh: true);

        //first date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(2);

        //second date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(2);
      });
      test("Should call again if change the enterprise", () async {
        await sut.getSales(now: now, homePresenter);

        //first date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //second date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //change enterprise
        homePresenter.selectedEnterpriseMock = EnterpriseModel.fromEntity(
                EntityFactory.makeEnterpriseEntity(
                    id: homePresenter.selectedEnterpriseMock!.id!.toInt() + 1))
            .toViewModel();

        await sut.getSales(now: now, homePresenter);

        //first date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //second date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });
      test("Should call again if change the selected date", () async {
        await sut.getSales(now: now, homePresenter);

        //first date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //second date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //change date
        final newDay = faker.randomGenerator.integer(28);
        homePresenter.selectedDateMock = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          newDay == homePresenter.selectedDateMock.day ? newDay + 1 : newDay,
        );

        await sut.getSales(now: now, homePresenter);

        //first date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //second date
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
                  23,
                  59,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });
      test("Should call with correct values when select today", () async {
        homePresenter.selectedDateMock = now;
        await sut.getSales(now: now, homePresenter);

        //first date
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
                  now.hour,
                  now.minute,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);

        //second date
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
                  now.hour,
                  now.minute,
                ),
                groupByDay: true,
                groupByEnterprise: true,
                enterpriseIds: [
                  homePresenter.selectedEnterpriseMock!.id!.toInt()
                ],
              ),
            )).called(1);
      });
      test("Should update selected period correctly", () async {
        await sut.getSales(
          now: now,
          homePresenter,
          periodType: PeriodType.daily,
          forceRefresh: true,
        );
        expect(sut.selectedPeriod, PeriodType.daily);

        await sut.getSales(
          now: now,
          homePresenter,
          periodType: PeriodType.monthly,
          forceRefresh: true,
        );
        expect(sut.selectedPeriod, PeriodType.monthly);
      });
    });

    group("Get compare month statistics", () {
      test("Should behave correctly when has previous year sales", () async {
        homePresenter.selectedDateMock = now;

        final defaultComparisonParams = GetSaleStatisticsParams(
          startDate: DateTime(0),
          endDate: DateTime(0),
          groupByMonth: true,
          groupByEnterprise: true,
          groupByYear: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        );

        final currentMonthComparisonParams = defaultComparisonParams.copyWith(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            0,
          ),
        );

        final previousYearComparisonParams = defaultComparisonParams.copyWith(
          startDate: DateTime(
            homePresenter.selectedDateMock.year - 1,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year - 1,
            homePresenter.selectedDateMock.month + 1,
            0,
          ),
        );

        final previousMonthComparisonParams = defaultComparisonParams.copyWith(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month - 1,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            0,
          ),
        );

        await sut.getSales(now: now, homePresenter);

        verify(() => loadSaleStatistics.get(currentMonthComparisonParams))
            .called(1);
        verify(() => loadSaleStatistics.get(previousYearComparisonParams))
            .called(1);
        verifyNever(
            () => loadSaleStatistics.get(previousMonthComparisonParams));

        expect(
            sut.lastGetMonthlyComparisonParams, previousYearComparisonParams);
      });
      test("Should behave correctly when DOESNT has previous year sales",
          () async {
        homePresenter.selectedDateMock = now;
        loadSaleStatistics.mockGet([]);
        final defaultComparisonParams = GetSaleStatisticsParams(
          startDate: DateTime(0),
          endDate: DateTime(0),
          groupByMonth: true,
          groupByEnterprise: true,
          groupByYear: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        );

        final currentMonthComparisonParams = defaultComparisonParams.copyWith(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            0,
          ),
        );

        final previousYearComparisonParams = defaultComparisonParams.copyWith(
          startDate: DateTime(
            homePresenter.selectedDateMock.year - 1,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year - 1,
            homePresenter.selectedDateMock.month + 1,
            0,
          ),
        );

        final previousMonthComparisonParams = defaultComparisonParams.copyWith(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month - 1,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            0,
          ),
        );

        await sut.getSales(now: now, homePresenter);

        verify(() => loadSaleStatistics.get(currentMonthComparisonParams))
            .called(1);
        verify(() => loadSaleStatistics.get(previousYearComparisonParams))
            .called(1);
        verify(() => loadSaleStatistics.get(previousMonthComparisonParams))
            .called(1);

        expect(
            sut.lastGetMonthlyComparisonParams, previousMonthComparisonParams);
      });
      test("Should add sales correctly", () async {
        homePresenter.selectedDateMock = faker.date.dateTime();
        await sut.getSales(now: now, homePresenter);

        expect(sut.monthlyComparison, [
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
        ]);
      });
    });
    test("Should add new analysis", () async {
      final index = faker.randomGenerator.integer(PeriodType.values.length);
      final periodType = PeriodType.values[index];

      await sut.getSales(
        homePresenter,
        periodType: periodType,
        forceRefresh: true,
        now: now,
      );

      verify(
        () => appAnalyticsService.addNewMonthlyAnalytic(
          reportType: ReportType.resume,
          periodType: periodType,
        ),
      ).called(1);
    });
  });
}

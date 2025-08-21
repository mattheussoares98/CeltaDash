import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:celta_dash/ui/services/services.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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
  late FirebaseManagerSpy firebaseManager;
  late MockedFirebaseGet mockedFirebaseGet;

  late List<SaleStatisticsEntity> saleStatisticsEntities;
  late DateTime now;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadSaleStatistics = LoadSaleStatisticsSpy();
    firebaseManager = FirebaseManagerSpy(
      mockedFirebaseGet: mockedFirebaseGet,
    );
  }

  void initPresenters() {
    sut = GetxResumePresenter(
      navigateTo: navigateTo,
      loadSaleStatistics: loadSaleStatistics,
      firebaseManager: firebaseManager,
    );
  }

  void initEntities() {
    now = DateTime.now();
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();

    saleStatisticsEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
    mockedFirebaseGet = MockedFirebaseGet(
      dataToReturn: [
        FakeDoc(
          {
            "${homePresenter.selectedEnterpriseMock?.id}-${DateFormat('yyyy-MM').format(homePresenter.selectedDate)}":
                {
              "value": faker.randomGenerator.decimal(),
              "userName": faker.person.name(),
            },
          },
          faker.guid.guid(),
        ),
      ],
    );
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticsEntities);
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
  }

  void initServices() {
    appAnalyticsService = AppAnalyticsServiceSpy();
    homePresenter = HomePresenterSpy();
    Get.put<HomePresenter>(homePresenter);
    Get.put<AppAnalyticsService>(appAnalyticsService);
  }

  setUp(() {
    initServices();
    initEntities();
    initUsecases();
    initPresenters();
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
    test("Should navigate to group summary correctly", () async {
      sut.goToGroupSummaryPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.groupSummary),
      ).called(1);
    });
    test("Should navigate to goal history page correctly", () async {
      sut.goToGoalHistoricPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.goalHistoric),
      ).called(1);
    });
  });

  group("Get sales", () {
    group("pattern", () {
      test("Should emit correct values on success", () async {
        expectLater(sut.mainErrorStream, emits(null));
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

        await sut.getSales(now: now);
      });

      test("Should emit correct values on error", () async {
        expectLater(
          sut.mainErrorStream,
          emitsInOrder([null, UIError.unexpected]),
        );
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

        loadSaleStatistics.mockGetError();

        await sut.getSales(now: now);
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(now: now);

        expect(
          sut.saleStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load sale movements with correct values", () async {
        await sut.getSales(now: now);

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
        await sut.getSales(now: now, periodType: PeriodType.monthly);
        await sut.getSales(now: now, periodType: PeriodType.monthly);

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
        await sut.getSales(now: now);
        await sut.getSales(now: now, forceRefresh: true);

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
      test("Should add new analysis", () async {
        final index = faker.randomGenerator.integer(PeriodType.values.length);
        final periodType = PeriodType.values[index];

        await sut.getSales(
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
    group("Get compare days statistics", () {
      test("Should update last get comparison sales params correctly",
          () async {
        await sut.getSales(now: now);

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
        await sut.getSales(now: now);

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
        await sut.getSales(now: now);

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
        await sut.getSales(now: now);

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
        await sut.getSales(now: now);
        await sut.getSales(now: now);

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
        await sut.getSales(now: now);
        await sut.getSales(now: now, forceRefresh: true);

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
        await sut.getSales(now: now);

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

        await sut.getSales(now: now);

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
        await sut.getSales(now: now);

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

        await sut.getSales(now: now);

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
        await sut.getSales(now: now);

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
          periodType: PeriodType.daily,
          forceRefresh: true,
        );
        expect(sut.selectedPeriod, PeriodType.daily);

        await sut.getSales(
          now: now,
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

        await sut.getSales(now: now);

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

        await sut.getSales(now: now);

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
        await sut.getSales(now: now);

        expect(sut.monthlyComparison, [
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
        ]);
      });
    });

    group("Get goals", () {
      test("Should load goals correctly", () async {
        await sut.getSales(now: now, forceRefresh: true);

        verify(() => firebaseManager.get(
                path:
                    "enterprises/${EnterpriseBuilder.entity!.firebaseId}/goals/all"))
            .called(1);
      });
      test("Should update local goals correctly", () async {
        expect(sut.goals, isEmpty);

        await sut.getSales(now: now, forceRefresh: true);

        expect(sut.goals, isNotEmpty);
      });
    });
  });

  group("Set goal", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.setGoal(faker.randomGenerator.decimal());
    });

    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      firebaseManager.mockPutError();

      await sut.setGoal(faker.randomGenerator.decimal());
    });
    test("Should call put with correct values", () async {
      final value = faker.randomGenerator.decimal();
      await sut.setGoal(value);

      final selectedEnterprise = homePresenter.selectedEnterpriseMock;
      verify(
        () => firebaseManager.put(
          path: "enterprises/${EnterpriseBuilder.entity!.firebaseId}/goals/all",
          data: {
            "${selectedEnterprise?.id}-${DateFormat('yyyy-MM').format(homePresenter.selectedDate)}":
                {
              "value": value,
              "userName": EnterpriseBuilder.entity?.bsUser?.name ?? '',
            }
          },
        ),
      );
    });
    test("Should update goals correctly", () async {
      final firstValue = faker.randomGenerator.decimal();
      await sut.setGoal(firstValue);

      expect(sut.goals, [
        GoalViewModel(
          FirebaseGoalEntity(
            enterpriseId: homePresenter.selectedEnterpriseMock!.id!.toInt(),
            year: homePresenter.selectedDate.year,
            month: homePresenter.selectedDate.month,
            value: firstValue,
            userName: EnterpriseBuilder.entity?.bsUser?.name ?? '',
            goalId:
                "${homePresenter.selectedEnterpriseMock?.id}-${DateFormat('yyyy-MM').format(homePresenter.selectedDate)}",
          ),
        ),
      ]);

      final secondValue = faker.randomGenerator.decimal();
      await sut.setGoal(secondValue);

      expect(sut.goals, [
        GoalViewModel(
          FirebaseGoalEntity(
            enterpriseId: homePresenter.selectedEnterpriseMock!.id!.toInt(),
            year: homePresenter.selectedDate.year,
            month: homePresenter.selectedDate.month,
            value: secondValue,
            userName: EnterpriseBuilder.entity?.bsUser?.name ?? '',
            goalId:
                "${homePresenter.selectedEnterpriseMock?.id}-${DateFormat('yyyy-MM').format(homePresenter.selectedDate)}",
          ),
        ),
      ]);
    });
  });
}

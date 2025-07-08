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
  late GetxDepartmentsPresenter sut;
  late HomePresenterSpy homePresenter;

  late AppAnalyticsServiceSpy appAnalyticsService;

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxDepartmentsPresenter(
      loadSaleStatistics: loadSaleStatistics,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleStatisticEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticEntities);
    homePresenter.selectedDateMock = faker.date.dateTime();
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
    homePresenter.enterprisesMock = [homePresenter.selectedEnterpriseMock!];
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

  group("Load sale movements", () {
    group("Pattern", () {
      test("Should emit correct values on success", () async {
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
        expectLater(sut.mainErrorStream, emits(null));

        await sut.getSales(homePresenter);
      });
      test("Should emit correct values on error", () async {
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
        expectLater(
          sut.mainErrorStream,
          emitsInOrder([null, UIError.unexpected]),
        );

        loadSaleStatistics.mockGetError();

        await sut.getSales(homePresenter);
      });
      test("Should update selected period correctly", () async {
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
        );
        expect(sut.selectedPeriod, PeriodType.daily);

        await sut.getSales(
          homePresenter,
          periodType: PeriodType.monthly,
        );
        expect(sut.selectedPeriod, PeriodType.monthly);

        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
        );
        expect(sut.selectedPeriod, PeriodType.daily);
      });
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.dailyStatistics,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlyStatistics,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should add new analysis", () async {
        final enabledPeriods = [PeriodType.daily, PeriodType.monthly];
        final periodType = enabledPeriods[faker.randomGenerator.integer(2)];

        await sut.getSales(
          homePresenter,
          periodType: periodType,
          forceRefresh: true,
        );

        verify(() => appAnalyticsService.addNewMonthlyAnalytic(
              reportType: ReportType.departments,
              periodType: periodType,
            )).called(1);
      });
    });

    group("Daily", () {
      test("Should load sales with correct params", () async {
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
        );

        verify(
          () => loadSaleStatistics.get(
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
              ),
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });

      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });
      test("Should update last get sales params correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        expect(
            sut.lastGetDailyParams,
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ));
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        expect(
          sut.dailyStatistics,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load again if change the selected enterprise", () async {
        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock = EnterpriseModel.fromEntity(
                EntityFactory.makeEnterpriseEntity(
                    id: homePresenter.selectedEnterpriseMock!.id!.toInt() + 1))
            .toViewModel();
        await sut.getSales(homePresenter);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });
    });

    group("Monthly", () {
      test("Should load sales with correct params", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
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
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });

      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
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
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
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
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });
      test("Should update last get sales params correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
            sut.lastGetMonthlyParams,
            GetSaleStatisticsParams(
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
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ));
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlyStatistics,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load again if change the selected enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
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
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
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
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          ),
        ).called(1);
      });
    });
  });
}

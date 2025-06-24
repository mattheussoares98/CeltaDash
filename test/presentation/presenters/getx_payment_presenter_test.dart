import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxPaymentTypePresenter sut;
  late HomePresenterSpy homePresenter;

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxPaymentTypePresenter(
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
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetSalesParams());
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
    });

    group("Daily", () {
      test("Should load sales with correct params", () async {
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
            ),
          ),
        ).called(1);
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
            ),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        await sut.getSales(homePresenter);

        verify(
          () => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: startDate,
              endDate: startDate,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: false,
              groupByYear: false,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
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
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            groupByDay: false,
            groupByMonth: true,
            groupByYear: true,
            groupByPaymentModality: true,
            groupByPaymentFinalization: true,
          ),
        );
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
            ),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock = EnterpriseModel.fromEntity(
                EntityFactory.makeEnterpriseEntity(
                    id: homePresenter.selectedEnterpriseMock!.id!.toInt() +
                        faker.randomGenerator.integer(100)))
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
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              groupByEnterprise: true,
              groupByDay: false,
              groupByMonth: true,
              groupByYear: true,
              groupByPaymentModality: true,
              groupByPaymentFinalization: true,
            ),
          ),
        ).called(1);
      });
    });
  });
}

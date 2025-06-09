import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxOperatorsPresenter sut;

  late HomePresenterSpy homePresenter;

  late EcLoadSaleStatisticsSpy ecLoadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    ecLoadSaleStatistics = EcLoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxOperatorsPresenter(
      ecLoadSaleStatistics: ecLoadSaleStatistics,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleStatisticsEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
  }

  void initMockSuccess() {
    ecLoadSaleStatistics.mockGet(saleStatisticsEntities);
    homePresenter.selectedEnterpriseMock =
        EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
            .toViewModel();
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

  group("Get sales", () {
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

        ecLoadSaleStatistics.mockGetError();

        await sut.getSales(homePresenter);
      });
      test("Should update period type correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        expect(sut.selectedPeriodValue, PeriodType.daily);

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        expect(sut.selectedPeriodValue, PeriodType.monthly);

        await sut.getSales(homePresenter, periodType: PeriodType.yearly);
        expect(sut.selectedPeriodValue, PeriodType.yearly);
      });
    });
    group("PeriodType.daily", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.dailyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByDay: true,
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
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByDay: true,
            ),
          ),
        ).called(1);
      });
      test("Should load again if change the enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByDay: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByDay: true,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
          forceRefresh: true,
        );

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByDay: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        expect(
            sut.lastGetDailyParams,
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByDay: true,
            ));
      });
    });
    group("PeriodType.monthly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);
      });

      test("Should load again if change the enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.monthly,
          forceRefresh: true,
        );

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByMonth: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          0,
        );

        expect(
            sut.lastGetMonthlyParams,
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByMonth: true,
            ));
      });
    });
    group("PeriodType.yearly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        expect(
          sut.yearlyStatistics,
          saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
      test("Should load again if force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.yearly,
          forceRefresh: true,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByYear: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        expect(
            sut.lastGetYearlyParams,
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByYear: true,
            ));
      });

      test("Should load again if change the enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByYear: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        verify(
          () => ecLoadSaleStatistics.get(
            GetEcSaleStatisticsParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByCashierOperator: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
    });
  });
}

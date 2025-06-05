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
  late GetxSalesPresenter sut;
  late HomePresenterSpy homePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxSalesPresenter(
      loadSaleMovements: loadSaleMovements,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleMovementEntities = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
    homePresenter.selectedDateMock = faker.date.dateTime();
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementEntities);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetSalesParams());
    registerFallbackValue(HomePresenterSpy());
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

        loadSaleMovements.mockGetError();

        await sut.getSales(homePresenter);
      });
      test("Should update period type correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        expect(sut.selectedPeriodType, PeriodType.daily);

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        expect(sut.selectedPeriodType, PeriodType.monthly);

        await sut.getSales(homePresenter, periodType: PeriodType.yearly);
        expect(sut.selectedPeriodType, PeriodType.yearly);
      });
    });
    group("PeriodType.daily", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleMovementsByDay,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
        ).subtract(Duration(days: 1));

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: true,
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
          1,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
        ).subtract(Duration(days: 1));

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: true,
            ),
          ),
        ).called(1);
      });
      test("Should load again if change the enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
        ).subtract(Duration(days: 1));

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: true,
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
          1,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
        ).subtract(Duration(days: 1));

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );

        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
        ).subtract(Duration(days: 1));

        expect(
            sut.lastGetDailyParams,
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByHour: true,
            ));
      });
    });
    group("PeriodType.monthly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.saleMovementsByMonth,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(homePresenter.selectedDateMock.year, 1, 1);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(homePresenter.selectedDateMock.year, 1, 1);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);
      });

      test("Should load again if change the enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        final startDate = DateTime(homePresenter.selectedDateMock.year, 1, 1);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByMonth: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
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

        final startDate = DateTime(homePresenter.selectedDateMock.year, 1, 1);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByMonth: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        final startDate = DateTime(homePresenter.selectedDateMock.year, 1, 1);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        expect(
            sut.lastGetMonthlyParams,
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByMonth: true,
            ));
      });
    });
    group("PeriodType.yearly", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        expect(
          sut.saleMovementsByYear,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
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

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
            ),
          ),
        ).called(2);
      });
      test("Should update lastGetSalesParams correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        expect(
            sut.lastGetYearlyParams,
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
            ));
      });

      test("Should load again if change the enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDateMock.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
            ),
          ),
        ).called(1);

        ////////////////////CHANGING ENTERPRISE/////////////////////////////////
        final newEnterprise =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        homePresenter.selectedEnterpriseMock = newEnterprise;
        await sut.getSales(homePresenter, periodType: PeriodType.yearly);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              enterpriseIds: [newEnterprise.id!.toInt()],
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByYear: true,
            ),
          ),
        ).called(1);
      });
    });
  });
}

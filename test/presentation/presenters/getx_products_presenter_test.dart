import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
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
  late GetxProductsPresenter sut;

  late HomePresenterSpy homePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;
  late LocalStorageSpy localStorage;

  late List<SaleMovementEntity> saleMovementsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
    localStorage = LocalStorageSpy();
  }

  void initPresenters() {
    sut = GetxProductsPresenter(
      loadSaleMovements: loadSaleMovements,
      localStorage: localStorage,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    saleMovementsEntities = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementsEntities);
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
    homePresenter.selectedDateMock = faker.date.dateTime();
  }

  setUp(() {
    initEntities();
    initUsecases();
    initPresenters();
    initMockSuccess();
  });

  setUpAll(() {
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }
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

        loadSaleMovements.mockGetError();

        await sut.getSales(homePresenter);
      });
      test("Should update selected period correctly", () async {
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
        );
        expect(sut.selectedPeriodValue, PeriodType.daily);

        await sut.getSales(
          homePresenter,
          periodType: PeriodType.monthly,
        );
        expect(sut.selectedPeriodValue, PeriodType.monthly);

        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
        );
        expect(sut.selectedPeriodValue, PeriodType.daily);
      });
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.dailySaleMovements,
          saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlySaleMovements,
          saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
    });

    group("Daily", () {
      test("Should load sales with correct params", () async {
        await sut.getSales(
          homePresenter,
          periodType: PeriodType.daily,
        );

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
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
              topCount: 200,
              groupByProduct: true,
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
          () => loadSaleMovements.get(
            GetSalesParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
          () => loadSaleMovements.get(
            GetSalesParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
            GetSalesParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ));
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        expect(
          sut.dailySaleMovements,
          saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
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
          () => loadSaleMovements.get(
            GetSalesParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
        await sut.getSales(homePresenter);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
              startDate: startDate,
              endDate: startDate,
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
          () => loadSaleMovements.get(
            GetSalesParams(
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
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
          () => loadSaleMovements.get(
            GetSalesParams(
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
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
          () => loadSaleMovements.get(
            GetSalesParams(
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
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
            GetSalesParams(
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
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ));
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlySaleMovements,
          saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load again if change the selected enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSalesParams(
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
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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
          () => loadSaleMovements.get(
            GetSalesParams(
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
              groupByDay: true,
              topCount: 200,
              groupByProduct: true,
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

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
  late GetxCanceledSalesPresenter sut;

  late HomePresenterSpy homePresenter;

  late EcLoadSaleMovementsSpy ecLoadSaleMovements;
  late NavigateToSpy navigateTo;

  late List<SaleMovementEntity> saleMovementEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    ecLoadSaleMovements = EcLoadSaleMovementsSpy();
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxCanceledSalesPresenter(
      ecLoadSaleMovements: ecLoadSaleMovements,
      navigateTo: navigateTo,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleMovementEntities = [
      EntityFactory.makeEcSaleMovementEntity(),
      EntityFactory.makeEcSaleMovementEntity(),
      EntityFactory.makeEcSaleMovementEntity(),
    ];
  }

  void initMockSuccess() {
    ecLoadSaleMovements.mockGet(saleMovementEntities);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetEcSaleMovementParams());
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

        ecLoadSaleMovements.mockGetError();

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
          sut.dailySales,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );

        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlySales,
          saleMovementEntities
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
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
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
              onlyCancelled: true,
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
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              onlyCancelled: true,
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
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
              onlyCancelled: true,
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
          GetEcSaleMovementParams(
            onlyCancelled: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            startDate: startDate,
            endDate: startDate,
          ),
        );
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);

        expect(
          sut.dailySales,
          saleMovementEntities
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
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
            ),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock =
            EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
                .toViewModel();
        await sut.getSales(homePresenter);

        verify(
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: startDate,
              endDate: startDate,
            ),
          ),
        ).called(1);
      });
    });

    group("Monthly", () {
      test("Should load sales with correct params", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
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
            ),
          ),
        ).called(1);
      });

      test("Should call load sale movements with correct values", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
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
            ),
          ),
        ).called(1);
      });
      test("Should not load again if dont force refresh", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
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
            ),
          ),
        ).called(1);
      });
      test("Should update last get sales params correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.lastGetMonthlyParams,
          GetEcSaleMovementParams(
            onlyCancelled: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
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
          ),
        );
      });

      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        expect(
          sut.monthlySales,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load again if change the selected enterprise", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
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
            ),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock =
            EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
                .toViewModel();
        await sut.getSales(homePresenter, periodType: PeriodType.monthly);

        verify(
          () => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              onlyCancelled: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
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
            ),
          ),
        ).called(1);
      });
    });
  });

  group("Update selected sale movement", () {
    test("Should update selected sale movement correctly", () {
      final newSaleMovement = SaleMovementModel.fromEntity(
        //TODO change to EcSaleMovementModel
        EntityFactory.makeEcSaleMovementEntity(),
      ).toViewModel();

      sut.updateSelectedSaleMovement(newSaleMovement);

      expect(sut.selectedSaleMovement, newSaleMovement);
    });

    test("Should go to canceled sale details page", () {
      final newSaleMovement = SaleMovementModel.fromEntity(
        EntityFactory.makeEcSaleMovementEntity(),
      ).toViewModel();

      sut.updateSelectedSaleMovement(newSaleMovement);

      verify(() =>
              navigateTo.navigate(pageRoute: PageRoutes.canceledSaleDetails))
          .called(1);
    });
  });

  group("Get selected sale movement details", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getSelectedSaleDetails();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      ecLoadSaleMovements.mockGetError();

      await sut.getSelectedSaleDetails();
    });
    test("Should call load sales with correct values", () async {
      final firstSale = SaleMovementModel.fromEntity(
        saleMovementEntities.first,
      ).toViewModel();

      sut.updateSelectedSaleMovement(firstSale);

      await sut.getSelectedSaleDetails();

      final sale = SaleMovementModel.fromViewModel(sut.selectedSaleMovement!);

      verify(() => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              documentNumbers: [sale.documentNumber!],
              enterpriseIds: [sale.enterpriseId!],
              startDate: sale.dateHourOfBilling!,
              endDate: sale.dateHourOfBilling!,
              mountCustomer: true,
              mountFiscalNoteType: true,
              mountPaymentFinalizations: true,
              mountProducts: true,
              mountSeller: true,
            ),
          )).called(1);
    });
    test("Should update selected sale correctly", () async {
      final newSale = SaleMovementModel.fromEntity(
        SaleMovementEntity(
          id: faker.randomGenerator.integer(100),
          enterpriseId: faker.randomGenerator.integer(100),
          fiscalNoteTypeId: faker.randomGenerator.integer(100),
          sellerId: faker.randomGenerator.integer(100),
          documentNumber: faker.randomGenerator.integer(100).toString(),
          cashierNumber: faker.randomGenerator.integer(100).toString(),
          dateHourOfBilling: faker.date.dateTime(),
          totalLiquid: faker.randomGenerator.decimal(),
          isCancelled: true,
          fiscalNoteType: null,
          customer: null,
          seller: null,
          products: null,
          paymentFinalizations: null,
        ),
      ).toViewModel();
      sut.updateSelectedSaleMovement(newSale);
      //change the selected enterprise, but...

      await sut.getSelectedSaleDetails();

      final sale = SaleMovementModel.fromEntity(saleMovementEntities.first)
          .toViewModel();
      //always will update the selectedSaleMovement again, using the first returned value in the usecase

      expect(sut.selectedSaleMovement, sale);
    });
  });
}

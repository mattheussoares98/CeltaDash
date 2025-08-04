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
  late GetxBsSalesPresenter sut;

  late HomePresenterSpy homePresenter;

  late AppAnalyticsServiceSpy appAnalyticsService;

  late LoadSaleMovementsSpy loadSaleMovements;
  late NavigateToSpy navigateTo;

  late List<SaleMovementEntity> saleMovementEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxBsSalesPresenter(
      loadSaleMovements: loadSaleMovements,
      navigateTo: navigateTo,
    );
  }

  void initEntities() {
    saleMovementEntities = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementEntities);
  }

  void initServices() {
    appAnalyticsService = AppAnalyticsServiceSpy();
    homePresenter = HomePresenterSpy();
    Get.put<AppAnalyticsService>(appAnalyticsService);
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

  group("Load CANCELED sales", () {
    group("Pattern", () {
      test("Should emit correct values on success", () async {
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
        expectLater(sut.mainErrorStream, emits(null));

        await sut.getCanceledSales(homePresenter);
      });
      test("Should emit correct values on error", () async {
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
        expectLater(
          sut.mainErrorStream,
          emitsInOrder([null, UIError.unexpected]),
        );

        loadSaleMovements.mockGetError();

        await sut.getCanceledSales(homePresenter);
      });
      test("Should update selected period correctly", () async {
        await sut.getCanceledSales(
          homePresenter,
          periodType: PeriodType.daily,
        );
        expect(sut.selectedPeriod, PeriodType.daily);

        await sut.getCanceledSales(
          homePresenter,
          periodType: PeriodType.monthly,
        );
        expect(sut.selectedPeriod, PeriodType.monthly);

        await sut.getCanceledSales(
          homePresenter,
          periodType: PeriodType.daily,
        );
        expect(sut.selectedPeriod, PeriodType.daily);
      });
      test("Should update sale movements correctly", () async {
        await sut.getCanceledSales(homePresenter);

        expect(
          sut.dailySales,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );

        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        expect(
          sut.monthlySales,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should call analytics service add new analytics", () async {
        final period = PeriodType
            .values[faker.randomGenerator.integer(PeriodType.values.length)];

        await sut.getCanceledSales(
          homePresenter,
          forceRefresh: true,
          periodType: period,
        );

        verify(
          () => appAnalyticsService.addNewMonthlyAnalytic(
            reportType: ReportType.canceledSales,
            periodType: period,
          ),
        ).called(1);
      });
    });

    group("Daily", () {
      test("Should load sales with correct params", () async {
        await sut.getCanceledSales(
          homePresenter,
          periodType: PeriodType.daily,
        );

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter, periodType: PeriodType.daily);
        await sut.getCanceledSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter, periodType: PeriodType.daily);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        expect(
          sut.lastGetDailyParams,
          GetSaleMovementParams(
            onlyCancelled: true,
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            startDate: startDate,
            endDate: startDate,
          ),
        );
      });

      test("Should update sale movements correctly", () async {
        await sut.getCanceledSales(homePresenter, periodType: PeriodType.daily);

        expect(
          sut.dailySales,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load again if change the selected enterprise", () async {
        await sut.getCanceledSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        await sut.getCanceledSales(homePresenter);

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        expect(
          sut.lastGetMonthlyParams,
          GetSaleMovementParams(
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
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        expect(
          sut.monthlySales,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load again if change the selected enterprise", () async {
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        await sut.getCanceledSales(homePresenter,
            periodType: PeriodType.monthly);

        verify(
          () => loadSaleMovements.get(
            GetSaleMovementParams(
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
        EntityFactory.makeSaleMovementEntity(),
      ).toViewModel();

      expectLater(
        sut.selectedSaleStream,
        emitsInOrder([null, newSaleMovement]),
      );

      sut.updateSelectedSaleMovement(newSaleMovement);
    });

    test("Should go to bs sale details page", () {
      final newSaleMovement = SaleMovementModel.fromEntity(
        EntityFactory.makeSaleMovementEntity(),
      ).toViewModel();

      sut.updateSelectedSaleMovement(newSaleMovement);

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.bsSaleDetails))
          .called(1);
    });
  });

  group("Get selected sale movement details", () {
    test("Should emit correct values on success", () async {
      final selected = SaleMovementModel.fromEntity(
        saleMovementEntities.first,
      ).toViewModel();

      final newSaleMovement = EntityFactory.makeSaleMovementEntity();
      final newSaleMovementViewModel = SaleMovementModel.fromEntity(
        newSaleMovement,
      ).toViewModel();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(
        sut.selectedSaleStream,
        emitsInOrder([null, selected, null, newSaleMovementViewModel]),
      );

      sut.updateSelectedSaleMovement(selected);

      loadSaleMovements.mockGet([newSaleMovement]);
      await sut.getSelectedSaleDetails();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleMovements.mockGetError();

      await sut.getSelectedSaleDetails();
    });
    test("Should call load sales with correct values", () async {
      final firstSale = SaleMovementModel.fromEntity(
        saleMovementEntities.first,
      ).toViewModel();

      sut.updateSelectedSaleMovement(firstSale);

      await sut.getSelectedSaleDetails();

      final sale = SaleMovementModel.fromEntity(saleMovementEntities.first);

      final date = DateTime(
        sale.dateHourOfBilling!.year,
        sale.dateHourOfBilling!.month,
        sale.dateHourOfBilling!.day,
      );

      verify(() => loadSaleMovements.get(
            GetSaleMovementParams(
              documentNumbers: [sale.documentNumber!],
              enterpriseIds: [sale.enterpriseId!],
              startDate: date,
              endDate: date,
              mountCustomer: true,
              mountFiscalNoteType: true,
              mountProducts: true,
              mountSeller: true,
              mountPaymentFinalizations: true,
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
          motiveCancellation: faker.lorem.word(),
          cashierNumber: faker.randomGenerator.integer(100).toString(),
          dateHourOfBilling: faker.date.dateTime(),
          dateHourOfCancellation: faker.date.dateTime(),
          totalLiquid: faker.randomGenerator.decimal(),
          isCancelled: true,
          fiscalNoteType: null,
          customer: null,
          seller: null,
          products: null,
          paymentFinalizations: null,
          userCancellation: null,
        ),
      ).toViewModel();
      sut.updateSelectedSaleMovement(newSale);
      //change the selected enterprise, but...

      final sale = SaleMovementModel.fromEntity(saleMovementEntities.first)
          .toViewModel();
      expectLater(sut.selectedSaleStream, emitsInOrder([null, sale]));

      await sut.getSelectedSaleDetails();
      //always will update the selectedSaleMovement again, using the first returned value in the usecase
    });
  });

  group("Load NOT canceled sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getNotCanceledSales();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleMovements.mockGetError();

      await sut.getNotCanceledSales();
    });
    test("Should update daily sales correctly", () async {
      await sut.getNotCanceledSales();

      expect(
        sut.dailySales,
        saleMovementEntities
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });
    test(
        "Should get sales with correct values when doesnt pass a date as parameter",
        () async {
      await sut.getNotCanceledSales();

      final date = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        homePresenter.selectedDate.day,
      );

      verify(() => loadSaleMovements.get(
            GetSaleMovementParams(
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              startDate: date,
              endDate: date,
            ),
          )).called(1);
    });
    test("Should add correct app analytics", () async {
      await sut.getNotCanceledSales();

      verify(() => appAnalyticsService.addNewMonthlyAnalytic(
            reportType: ReportType.notCanceledSales,
            periodType: PeriodType.daily,
          )).called(1);
    });
  });
}

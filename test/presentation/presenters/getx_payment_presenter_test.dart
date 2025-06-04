import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
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

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntitys;
  late EnterpriseEntity selectedEnterprise;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxPaymentTypePresenter(
      loadSaleMovements: loadSaleMovements,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleMovementEntitys = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
    selectedEnterprise = EntityFactory.makeEnterpriseEntity();
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementEntitys);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });

  group("Get sales", () {
    group("Pattern requests", () {
      test("Should emit correct values on success", () async {
        expectLater(sut.mainErrorStream, emits(null));
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

        await sut.getSales(homePresenter);
      });

      test("Should emit correct values on error", () async {
        expectLater(
          sut.mainErrorStream,
          emitsInOrder([null, UIError.unexpected]),
        );
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

        loadSaleMovements.mockGetError();

        await sut.getSales(homePresenter);
      });
    });

    group("Sales movements by modality", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleMovements,
          saleMovementEntitys
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should update last date loaded data correctly", () async {
        homePresenter.selectedDateMock = faker.date.dateTime();

        await sut.getSales(homePresenter);

        expect(sut.lastDateLoadedData, homePresenter.selectedDateMock);
      });

      test("Should load sale movements with correct values", () async {
        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => loadSaleMovements.get(
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByDay: true,
              groupByPaymentModality: true,
            )).called(1);
      });
      test("Should load sale movements with correct new date", () async {
        homePresenter.selectedDateMock = faker.date.dateTime();
        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => loadSaleMovements.get(
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByDay: true,
              groupByPaymentModality: true,
            )).called(1);
      });
      test("Should not load sale movements if dont change the month", () async {
        homePresenter.selectedDateMock = faker.date.dateTime();

        await sut.getSales(homePresenter);

        homePresenter.selectedDateMock = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          faker.randomGenerator.integer(28),
        );
        await sut.getSales(homePresenter);

        verify(() => loadSaleMovements.get(
              groupByEnterprise: true,
              groupByDay: true,
              groupByPaymentModality: true,
              startDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month,
                1,
              ),
              endDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month + 1,
                1,
              ).subtract(Duration(days: 1)),
            )).called(1);
      });
      test(
          "Should load sale movements if dont change the month but force refresh",
          () async {
        homePresenter.selectedDateMock = faker.date.dateTime();

        await sut.getSales(homePresenter);
        await sut.getSales(homePresenter, forceRefresh: true);

        verify(() => loadSaleMovements.get(
              groupByEnterprise: true,
              groupByDay: true,
              groupByPaymentModality: true,
              startDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month,
                1,
              ),
              endDate: DateTime(
                homePresenter.selectedDateMock.year,
                homePresenter.selectedDateMock.month + 1,
                1,
              ).subtract(Duration(days: 1)),
            )).called(2);
      });
    });

    group("Sales movements by finalizations", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleMovementsByFinalizations,
          saleMovementEntitys
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load sale movements with correct values", () async {
        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => loadSaleMovements.get(
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByDay: true,
              groupByPaymentFinalization: true,
            )).called(1);
      });
      test("Should load sale movements with correct new date", () async {
        homePresenter.selectedDateMock = faker.date.dateTime();
        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(selectedEnterprise).toViewModel();

        await sut.getSales(homePresenter);

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month + 1,
          1,
        ).subtract(Duration(days: 1));

        verify(() => loadSaleMovements.get(
              startDate: startDate,
              endDate: endDate,
              groupByEnterprise: true,
              groupByDay: true,
              groupByPaymentFinalization: true,
            )).called(1);
      });
    });
  });
}

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
  late GetxSellersPresenter sut;

  late HomePresenterSpy homePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxSellersPresenter(
      loadSaleMovements: loadSaleMovements,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
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

  group("Load sales movements", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getSales(homePresenter);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadSaleMovements.mockGetError();

      await sut.getSales(homePresenter);
    });

    test("Should update secondDaySaleMovements correctly", () async {
      await sut.getSales(homePresenter);

      expect(
          sut.saleMovements,
          saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList());
    });

    test("Should call get sales correct parameters", () async {
      await sut.getSales(homePresenter);

      verify(
        () => loadSaleMovements.get(
          groupByHour: true,
          groupBySeller: true,
          groupByEnterprise: true,
          // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            1,
          ).subtract(Duration(days: 1)),
        ),
      ).called(1);
    });
    test("Should update last date laoded data correctly", () async {
      await sut.getSales(homePresenter);

      expect(sut.lastDateLoadedData, homePresenter.selectedDateMock);
    });

    test("Should not load sales again if dont change the year", () async {
      await sut.getSales(homePresenter);

      verify(
        () => loadSaleMovements.get(
          groupByHour: true,
          groupBySeller: true,
          groupByEnterprise: true,
          // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            1,
          ).subtract(Duration(days: 1)),
        ),
      ).called(1);

      final newDate = DateTime(
        homePresenter.selectedDateMock.year,
        faker.randomGenerator.integer(12),
        faker.randomGenerator.integer(28),
      );

      homePresenter.selectedDateMock = newDate;

      await sut.getSales(homePresenter);
      verifyNever(
        () => loadSaleMovements.get(
          groupByHour: true,
          groupBySeller: true,
          groupByEnterprise: true,
          // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(newDate.year, 1, 1),
          endDate: DateTime(
            newDate.year,
            newDate.month + 1,
            1,
          ).subtract(Duration(days: 1)),
        ),
      );
    });
    test("Should load again if change the year", () async {
      await sut.getSales(homePresenter);

      verify(
        () => loadSaleMovements.get(
          groupByHour: true,
          groupBySeller: true,
          groupByEnterprise: true,
          // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            1,
          ).subtract(Duration(days: 1)),
        ),
      ).called(1);

      homePresenter.selectedDateMock = DateTime(
        homePresenter.selectedDateMock.year + faker.randomGenerator.integer(99),
        faker.randomGenerator.integer(12),
        faker.randomGenerator.integer(28),
      );

      await sut.getSales(homePresenter);
      verify(
        () => loadSaleMovements.get(
          groupByHour: true,
          groupBySeller: true,
          groupByEnterprise: true,
          // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            1,
          ).subtract(Duration(days: 1)),
        ),
      ).called(1);
    });
    test("Should load again if force refresh", () async {
      await sut.getSales(homePresenter);
      await sut.getSales(homePresenter, forceRefresh: true);

      verify(
        () => loadSaleMovements.get(
          groupByHour: true,
          groupBySeller: true,
          groupByEnterprise: true,
          // enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
            1,
          ).subtract(Duration(days: 1)),
        ),
      ).called(2);
    });

    test("Should call home presenter update screen", () async {
      await sut.getSales(homePresenter);

      verify(() => homePresenter.updateScreen()).called(1);
    });
  });
}

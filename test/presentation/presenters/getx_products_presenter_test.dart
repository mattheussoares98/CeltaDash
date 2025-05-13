import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
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

  late List<SaleMovementEntity> saleMovementsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxProductsPresenter(
      loadSaleMovements: loadSaleMovements,
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

  group("Load sale movements", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadProducts(homePresenter);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleMovements.mockGetError();

      await sut.loadProducts(homePresenter);
    });
    test("Should call load sale movements with correct values", () async {
      await sut.loadProducts(homePresenter);

      verify(
        () => loadSaleMovements.get(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
          ).subtract(Duration(days: 1)),
          groupByDay: true,
          groupByProduct: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        ),
      ).called(1);
    });

    test("Should update sale movements correctly", () async {
      await sut.loadProducts(homePresenter);

      expect(
        sut.saleMovements,
        saleMovementsEntities
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });
    test("Should update lastDateLoadedData correctly", () async {
      await sut.loadProducts(homePresenter);

      expect(sut.lastDateLoadedData, homePresenter.selectedDateMock);
    });
    test(
        "Should not load again if lastDateLoadedData is equal homePresenter.selectedDate",
        () async {
      await sut.loadProducts(homePresenter);
      await sut.loadProducts(homePresenter);

      verify(
        () => loadSaleMovements.get(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
          ).subtract(Duration(days: 1)),
          groupByDay: true,
          groupByProduct: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        ),
      ).called(1);
    });
    test("Should load again if change the date", () async {
      await sut.loadProducts(homePresenter);
      homePresenter.selectedDateMock = faker.date.dateTime();

      await sut.loadProducts(homePresenter);

      verify(
        () => loadSaleMovements.get(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
          ).subtract(Duration(days: 1)),
          groupByDay: true,
          groupByProduct: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        ),
      ).called(1);
    });
    test("Should load again if force refresh", () async {
      await sut.loadProducts(homePresenter);
      await sut.loadProducts(homePresenter, forceRefresh: true);

      verify(
        () => loadSaleMovements.get(
          startDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDateMock.year,
            homePresenter.selectedDateMock.month + 1,
          ).subtract(Duration(days: 1)),
          groupByDay: true,
          groupByProduct: true,
          groupByEnterprise: true,
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
        ),
      ).called(2);
    });
  });
}

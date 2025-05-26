import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxOperatorsProductivityPresenter sut;

  late HomePresenterSpy homePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementsEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxOperatorsProductivityPresenter(
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
          groupByMonth: true,
          groupByDay: true,
          groupByHour: true,
          groupByCashierOperator: true,
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
  });
}

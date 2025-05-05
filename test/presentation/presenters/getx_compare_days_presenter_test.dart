import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late GetxCompareDaysPresenter sut;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementsEntities;
  late DateTime firstDay;
  late DateTime secondDay;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxCompareDaysPresenter(
      loadSaleMovements: loadSaleMovements,
    );
  }

  void initEntities() {
    saleMovementsEntities = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
    firstDay = faker.date.dateTime();
    secondDay = faker.date.dateTime();
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementsEntities);
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

      await sut.getSales(firstDay: firstDay, secondDay: secondDay);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadSaleMovements.mockGetError();

      await sut.getSales(firstDay: firstDay, secondDay: secondDay);
    });
    test("Should update firstDaySaleMovements correctly", () async {
      await sut.getSales(firstDay: firstDay, secondDay: secondDay);

      expect(
        sut.firstDayMovements,
        saleMovementsEntities
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });
    test("Should update secondDaySaleMovements correctly", () async {
      await sut.getSales(firstDay: firstDay, secondDay: secondDay);

      expect(
        sut.secondDayMovements,
        saleMovementsEntities
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });
    test("Should update selected first day correctly", () async {
      await sut.getSales(firstDay: firstDay, secondDay: secondDay);

      expect(sut.selectedFirstDay, firstDay);
    });
    test("Should update selected second day correctly", () async {
      await sut.getSales(firstDay: firstDay, secondDay: secondDay);

      expect(sut.selectedSecondDay, secondDay);
    });
    test("Should call load first day with correct parameters", () async {
      await sut.getSales(firstDay: firstDay, secondDay: secondDay);

      verify(
        () => loadSaleMovements.get(startDate: firstDay, endDate: firstDay),
      ).called(1);
    });
    test("Should call load second day with correct parameters", () async {
      await sut.getSales(firstDay: firstDay, secondDay: secondDay);

      verify(
        () => loadSaleMovements.get(startDate: secondDay, endDate: secondDay),
      ).called(1);
    });
  });
}

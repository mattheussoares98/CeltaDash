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
import '../mocks/mocks.dart';

void main() {
  late GetxCompareDaysPresenter sut;

  late HomePresenterSpy homePresenter;

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
    homePresenter = HomePresenterSpy();
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

      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: secondDay,
      );
    });
    test("Should emit correct values on select same days", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.sameDays]));

      loadSaleMovements.mockGetError();

      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: firstDay,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadSaleMovements.mockGetError();

      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: secondDay,
      );
    });
    test("Should update firstDaySaleMovements correctly", () async {
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: secondDay,
      );

      expect(
        sut.saleMovements,
        [
          ...saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel()),
          ...saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
        ],
      );
    });
    test("Should update secondDaySaleMovements correctly", () async {
      await sut.getSales(
          homePresenter: homePresenter,
          firstDay: firstDay,
          secondDay: secondDay);

      expect(
        sut.saleMovements,
        [
          ...saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel()),
          ...saleMovementsEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
        ],
      );
    });
    test("Should update selected first day correctly", () async {
      await sut.getSales(
          homePresenter: homePresenter,
          firstDay: firstDay,
          secondDay: secondDay);

      expect(sut.selectedFirstDay, firstDay);
    });
    test("Should update selected second day correctly", () async {
      await sut.getSales(
          homePresenter: homePresenter,
          firstDay: firstDay,
          secondDay: secondDay);

      expect(sut.selectedSecondDay, secondDay);
    });
    test("Should call load first day with correct parameters", () async {
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: null,
      );

      verify(
        () => loadSaleMovements.get(
          groupByYear: true,
          groupByMonth: true,
          groupByDay: true,
          groupByHour: true,
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: firstDay,
          endDate: DateTime(
            firstDay.year,
            firstDay.month,
            firstDay.day,
            23,
            59,
            59,
          ),
        ),
      ).called(1);
    });
    test("Should call load second day with correct parameters", () async {
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: null,
        secondDay: secondDay,
      );

      verify(
        () => loadSaleMovements.get(
            groupByYear: true,
            groupByMonth: true,
            groupByDay: true,
            groupByHour: true,
            enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
            startDate: secondDay,
            endDate: DateTime(
              secondDay.year,
              secondDay.month,
              secondDay.day,
              23,
              59,
              59,
            )),
      ).called(1);
    });
  });

  group("Clear", () {
    test("Should clear sale movements", () async {
      await sut.getSales(
        firstDay: firstDay,
        secondDay: secondDay,
        homePresenter: homePresenter,
      );
      expect(sut.saleMovements, isNotNull);

      sut.clear();
      expect(sut.saleMovements, isNull);
    });
  });
}

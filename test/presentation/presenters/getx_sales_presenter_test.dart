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
  late GetxSalesPresenter sut;
  late HomePresenterSpy homePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntitys;

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
    saleMovementEntitys = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
    homePresenter.selectedDateMock = faker.date.dateTime();
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
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
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getSales(
        homePresenter: homePresenter,
        searchByHour: true,
        searchByDay: true,
        searchByMonth: true,
        searchByYear: true,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleMovements.mockGetError();

      await sut.getSales(
        homePresenter: homePresenter,
        searchByHour: true,
        searchByDay: true,
        searchByMonth: true,
        searchByYear: true,
      );
    });
    test("Should emit correct values when dont filter any period of time",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      await sut.getSales(
        homePresenter: homePresenter,
        searchByHour: false,
        searchByDay: false,
        searchByMonth: false,
        searchByYear: false,
      );
    });
    test("Should load sale movements with correct params when filter day",
        () async {
      await sut.getSales(homePresenter: homePresenter, searchByDay: true);

      verify(
        () => loadSaleMovements.get(
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
          groupByEnterprise: true,
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
          groupByYear: false,
          groupByMonth: false,
          groupByDay: true,
          groupByHour: true,
        ),
      );
    });
    test("Should load sale movements with correct params when filter hour",
        () async {
      await sut.getSales(homePresenter: homePresenter, searchByHour: true);

      verify(
        () => loadSaleMovements.get(
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
          groupByEnterprise: true,
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
          groupByYear: false,
          groupByMonth: false,
          groupByDay: true,
          groupByHour: true,
        ),
      );
    });
    test("Should load sale movements with correct params when filter month",
        () async {
      await sut.getSales(homePresenter: homePresenter, searchByMonth: true);

      verify(
        () => loadSaleMovements.get(
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
          groupByEnterprise: true,
          startDate: DateTime(homePresenter.selectedDateMock.year),
          endDate: DateTime(homePresenter.selectedDateMock.year),
          groupByYear: true,
          groupByMonth: true,
          groupByDay: false,
          groupByHour: false,
        ),
      );
    });
    test("Should load sale movements with correct params when filter year",
        () async {
      await sut.getSales(homePresenter: homePresenter, searchByMonth: true);

      verify(
        () => loadSaleMovements.get(
          enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
          groupByEnterprise: true,
          startDate: DateTime(homePresenter.selectedDateMock.year),
          endDate: DateTime(homePresenter.selectedDateMock.year),
          groupByYear: true,
          groupByMonth: true,
          groupByDay: false,
          groupByHour: false,
        ),
      );
    });
  });
}

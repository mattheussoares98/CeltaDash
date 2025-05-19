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
  late GetxDepartmentsPresenter sut;
  late HomePresenterSpy homePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntitys;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleMovements = LoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxDepartmentsPresenter(
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
  }

  void initMockSuccess() {
    loadSaleMovements.mockGet(saleMovementEntitys);
    homePresenter.selectedDateMock = faker.date.dateTime();
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

    group("Sales movements by departments and sections", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleMovements,
          saleMovementEntitys
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should load sale movements with correct values", () async {
        await sut.getSales(homePresenter);

        verify(() => loadSaleMovements.get(
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
              enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
            )).called(1);
      });
      test("Should load sale movements with correct new date", () async {
        await sut.getSales(homePresenter);

        verify(() => loadSaleMovements.get(
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
              enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
            )).called(1);
      });
      test("Should not load again if dont change the month", () async {
        await sut.getSales(homePresenter);

        homePresenter.selectedDateMock = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          faker.randomGenerator.integer(28),
        );
        await sut.getSales(homePresenter);

        verify(() => loadSaleMovements.get(
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
              enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
            )).called(1);
      });
      test("Should load again if dont change the month but force refresh",
          () async {
        await sut.getSales(homePresenter);

        homePresenter.selectedDateMock = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          faker.randomGenerator.integer(28),
        );
        await sut.getSales(homePresenter, forceRefresh: true);

        verify(() => loadSaleMovements.get(
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
              enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
              groupByEnterprise: true,
              groupByDay: true,
              groupByMonth: true,
              groupByProductDepartment: true,
              groupByProductSection: true,
            )).called(2);
      });
      test("Should change last loaded data correctly", () async {
        await sut.getSales(homePresenter, forceRefresh: true);

        expect(sut.lastDateLoadedData, homePresenter.selectedDateMock);
      });
    });
  });
}

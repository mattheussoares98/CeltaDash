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
  late ResumePresenterSpy resumePresenter;

  late LoadSaleMovementsSpy loadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntities;

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
    resumePresenter = ResumePresenterSpy();
  }

  void initEntities() {
    saleMovementEntities = [
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
    loadSaleMovements.mockGet(saleMovementEntities);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
    registerFallbackValue(HomePresenterSpy());
  });

  group("Get sales", () {
    group("Emits", () {
      test("Should emit correct values on success", () async {
        expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
        expectLater(sut.mainErrorStream, emits(null));

        await sut.getSales(
          resumePresenter: resumePresenter,
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
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
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
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByHour: false,
          searchByDay: false,
          searchByMonth: false,
          searchByYear: false,
        );
      });
    });
    group("Sale movements get sales", () {
      test("Should call resumePresenter.getSales when filter day", () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByDay: true,
        );

        verify(
          () => resumePresenter.getSales(homePresenter),
        ).called(1);
      });
      test("Should load resumePresenter.getSales when filter hour", () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByHour: true,
        );

        verify(
          () => resumePresenter.getSales(homePresenter),
        ).called(1);
      });

      test(
          "Should resumePresenter.getSales with correct params if pass the same date and force refresh",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByMonth: true,
          searchByDay: true,
          forceRefresh: true,
        );

        verify(
          () => resumePresenter.getSales(homePresenter, forceRefresh: true),
        ).called(1);
      });

      test(
          "Should resumePresenter.getSales with correct params if pass the same date and dont force refresh",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByMonth: true,
          searchByDay: true,
          forceRefresh: false,
        );

        verify(
          () => resumePresenter.getSales(homePresenter, forceRefresh: false),
        ).called(1);
      });
    });

    group("Sale movements by month && year", () {
      test("Should load sale movements with correct params to filter month",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByMonth: true,
        );

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
            endDate: DateTime(homePresenter.selectedDateMock.year, 12, 31),
            groupByYear: true,
            groupByMonth: true,
          ),
        ).called(1);
      });
      test("Should load sale movements with correct params to filter year",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByYear: true,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(homePresenter.selectedDate.year, 12, 31);

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            groupByYear: true,
            startDate: startDate,
            endDate: endDate,
          ),
        ).called(1);
      });

      test("Should not load sale movements when filter day or hour", () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByHour: true,
          searchByDay: true,
        );

        verifyNever(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            startDate: DateTime(homePresenter.selectedDateMock.year),
            endDate: DateTime(homePresenter.selectedDateMock.year),
            groupByYear: true,
            groupByMonth: true,
          ),
        );
      });
      test(
          "Should update saleMovements by month and sale movements by year correctly",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByYear: true,
        );

        final sales = saleMovementEntities
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList();
        expect(sut.saleMovementsByMonth, sales);
        expect(sut.saleMovementsByYear, sales);
      });

      test("Should update saleMovements from resumePresenter as well",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          searchByYear: true,
        );

        verify(() =>
                resumePresenter.getSales(homePresenter, forceRefresh: true))
            .called(1);
      });
    });
  });
}

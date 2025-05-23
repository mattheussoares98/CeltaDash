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
  late bool filterByDay;
  late bool filterByHour;
  late bool filterByMonth;
  late bool filterByYear;
  late DateTime now;

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
    now = DateTime.now();
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
        );
      });
    });

    group("Sale movements by month && year", () {
      test("Should load sale movements with correct params to filter month",
          () async {
        sut.updateSelectedPeriod(filterByMonth: true);

        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
            endDate: DateTime(now.year, now.month, now.day),
            groupByYear: true,
            groupByMonth: true,
          ),
        ).called(1);
      });
      test("Should load sale movements with correct params to filter year",
          () async {
        sut.updateSelectedPeriod(filterByYear: true);
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(now.year, now.month, now.day);

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
        sut.updateSelectedPeriod(filterByDay: true, filterByHour: true);
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
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
        sut.updateSelectedPeriod(filterByYear: true);
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        final sales = saleMovementEntities
            .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
            .toList();
        expect(sut.saleMovementsByMonth, sales);
        expect(sut.saleMovementsByYear, sales);
      });

      test("Should update lastDateLoadedData", () async {
        sut.updateSelectedPeriod(filterByYear: true);
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        expect(sut.lastDateLoadedData, homePresenter.selectedDateMock);
      });

      test(
          "Should not load sale movements again by month when dont change the month or year",
          () async {
        sut.updateSelectedPeriod(filterByMonth: true);

        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
            endDate: DateTime(now.year, now.month, now.day),
            groupByYear: true,
            groupByMonth: true,
          ),
        ).called(1);
      });
      test(
          "Should  load sale movements again by month when dont change the month or year but force refresh",
          () async {
        sut.updateSelectedPeriod(filterByMonth: true);

        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          forceRefresh: true,
        );

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            startDate: DateTime(homePresenter.selectedDateMock.year, 1, 1),
            endDate: DateTime(now.year, now.month, now.day),
            groupByYear: true,
            groupByMonth: true,
          ),
        ).called(2);
      });

      test(
          "Should not load sale movements by year when dont change selected year",
          () async {
        sut.updateSelectedPeriod(filterByYear: true);
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(now.year, now.month, now.day);

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
      test(
          "Should load sale movements by year AGAIN when dont change selected year but force refresh",
          () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
          forceRefresh: true,
        );

        final startDate = DateTime(homePresenter.selectedDateMock.year - 2);
        final endDate = DateTime(now.year, now.month, now.day);

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            groupByYear: true,
            startDate: startDate,
            endDate: endDate,
          ),
        ).called(2);
      });
      test("Should update lastEnterpriseLoadedData", () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        expect(
          sut.lastEnterpriseLoadedData,
          homePresenter.selectedEnterpriseMock,
        );
      });
      test("Should not load again if dont change the enterprise", () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            groupByYear: true,
            startDate: DateTime(homePresenter.selectedDateMock.year - 2),
            endDate: DateTime(now.year, now.month, now.day),
          ),
        ).called(1);
      });
      test("Should load again if change the enterprise", () async {
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );
        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            groupByYear: true,
            startDate: DateTime(homePresenter.selectedDateMock.year - 2),
            endDate: DateTime(now.year, now.month, now.day),
          ),
        ).called(1);

        homePresenter.selectedEnterpriseMock =
            EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
                .toViewModel();
        await sut.getSales(
          resumePresenter: resumePresenter,
          homePresenter: homePresenter,
        );

        verify(
          () => loadSaleMovements.get(
            enterpriseIds: [homePresenter.selectedEnterpriseMock!.id!.toInt()],
            groupByEnterprise: true,
            groupByYear: true,
            startDate: DateTime(homePresenter.selectedDateMock.year - 2),
            endDate: DateTime(now.year, now.month, now.day),
          ),
        ).called(1);
      });
    });
  });

  group("Update selected period", () {
    test("Should update values correctly", () {
      filterByDay = faker.randomGenerator.boolean();
      filterByHour = faker.randomGenerator.boolean();
      filterByMonth = faker.randomGenerator.boolean();
      filterByYear = faker.randomGenerator.boolean();

      sut.updateSelectedPeriod(
        filterByDay: filterByDay,
        filterByHour: filterByHour,
        filterByMonth: filterByMonth,
        filterByYear: filterByYear,
      );

      expect(sut.filterByHour, filterByHour);
      expect(sut.filterByDay, filterByDay);
      expect(sut.filterByMonth, filterByMonth);
      expect(sut.filterByYear, filterByYear);
    });
    test("Should start with correct values", () {
      expect(sut.filterByHour, true);
      expect(sut.filterByDay, false);
      expect(sut.filterByMonth, false);
      expect(sut.filterByYear, false);
    });
  });
}

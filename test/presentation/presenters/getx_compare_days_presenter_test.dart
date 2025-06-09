import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
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
  late GetxCompareDaysPresenter sut;

  late HomePresenterSpy homePresenter;

  late EcLoadSaleStatisticsSpy ecLoadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticsEntities;
  late DateTime firstDay;
  late DateTime secondDay;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    ecLoadSaleStatistics = EcLoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxCompareDaysPresenter(
      ecLoadSaleStatistics: ecLoadSaleStatistics,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleStatisticsEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
    firstDay = faker.date.dateTime();
    secondDay = faker.date.dateTime();
  }

  void initMockSuccess() {
    ecLoadSaleStatistics.mockGet(saleStatisticsEntities);
    homePresenter.selectedEnterpriseMock =
        EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity())
            .toViewModel();
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetSalesParams());
  });

  group("Load sales Statistics", () {
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

      ecLoadSaleStatistics.mockGetError();

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

      ecLoadSaleStatistics.mockGetError();

      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: secondDay,
      );
    });
    test("Should update firstDaySaleStatistics correctly", () async {
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: secondDay,
      );

      expect(
        sut.saleStatistics,
        [
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
        ],
      );
    });
    test("Should update secondDaySaleStatistics correctly", () async {
      await sut.getSales(
          homePresenter: homePresenter,
          firstDay: firstDay,
          secondDay: secondDay);

      expect(
        sut.saleStatistics,
        [
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
          ...saleStatisticsEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
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
        () => ecLoadSaleStatistics.get(
          GetEcSaleStatisticsParams(
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
            ),
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
        () => ecLoadSaleStatistics.get(
          GetEcSaleStatisticsParams(
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
            ),
          ),
        ),
      ).called(1);
    });
    test("Should not load again if dont change the second day", () async {
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: null,
        secondDay: secondDay,
      );
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: null,
        secondDay: secondDay,
      );

      verify(
        () => ecLoadSaleStatistics.get(
          GetEcSaleStatisticsParams(
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
            ),
          ),
        ),
      ).called(1);
    });
    test("Should not load again if dont change the first day", () async {
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: null,
      );
      await sut.getSales(
        homePresenter: homePresenter,
        firstDay: firstDay,
        secondDay: null,
      );

      verify(
        () => ecLoadSaleStatistics.get(
          GetEcSaleStatisticsParams(
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
            ),
          ),
        ),
      ).called(1);
    });
  });
}

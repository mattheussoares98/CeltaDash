import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
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
  late GetxDepartmentsPresenter sut;
  late HomePresenterSpy homePresenter;

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxDepartmentsPresenter(
      loadSaleStatistics: loadSaleStatistics,
    );
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleStatisticEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticEntities);
    homePresenter.selectedDateMock = faker.date.dateTime();
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
    homePresenter.enterprisesMock = [homePresenter.selectedEnterpriseMock!];
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

        loadSaleStatistics.mockGetError();

        await sut.getSales(homePresenter);
      });
    });

    group("Sales movements by departments and sections", () {
      test("Should update sale movements correctly", () async {
        await sut.getSales(homePresenter);

        expect(
          sut.saleStatistics,
          saleStatisticEntities
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });

      test("Should update GetSalesParams correctly on PeriodType.daily",
          () async {
        await sut.getSales(
          homePresenter,
          forceRefresh: true,
          periodType: PeriodType.daily,
        );

        final startDate = DateTime(
          homePresenter.selectedDateMock.year,
          homePresenter.selectedDateMock.month,
          homePresenter.selectedDateMock.day,
        );
        expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
            startDate: startDate,
            endDate: startDate,
            groupByEnterprise: true,
            groupByDay: true,
            groupByProductDepartment: true,
            groupByProductSection: true,
          ),
        );
      });
      test("Should update GetSalesParams correctly on PeriodType.monthly",
          () async {
        await sut.getSales(
          homePresenter,
          forceRefresh: true,
          periodType: PeriodType.monthly,
        );

        expect(
          sut.lastGetStatisticsParams,
          GetSaleStatisticsParams(
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
            groupByEnterprise: true,
            groupByDay: true,
            groupByProductDepartment: true,
            groupByProductSection: true,
          ),
        );
      });

      test(
          "Should update sale movements correctly when load more than one time",
          () async {
        final enterpriseId = homePresenter.selectedEnterpriseMock!.id!.toInt();
        final firstTimeLoaded = [
          EntityFactory.makeSaleStatisticEntity(enterpriseId: enterpriseId),
        ];
        loadSaleStatistics.mockGet(firstTimeLoaded);

        await sut.getSales(homePresenter);
        expect(
          sut.saleStatistics,
          firstTimeLoaded
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );

        final secondTimeLoaded = [
          EntityFactory.makeSaleStatisticEntity(enterpriseId: enterpriseId),
        ];

        loadSaleStatistics.mockGet(secondTimeLoaded);
        await sut.getSales(homePresenter, forceRefresh: true);
        expect(
          sut.saleStatistics,
          secondTimeLoaded
              .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
              .toList(),
        );
      });
      test("Should update selected period type correctly", () async {
        await sut.getSales(homePresenter, periodType: PeriodType.daily);
        expect(sut.selectedPeriodValue, PeriodType.daily);

        await sut.getSales(
          homePresenter,
          periodType: PeriodType.monthly,
          forceRefresh: true,
        );
        expect(sut.selectedPeriodValue, PeriodType.monthly);
      });
    });
  });
}

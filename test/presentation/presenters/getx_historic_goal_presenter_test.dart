import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxHistoricGoalPresenter sut;

  late HomePresenterSpy homePresenter;
  late ResumePresenterSpy resumePresenter;

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticEntities;
  late DateTime now;
  late List<GoalViewModel> firebaseGoals;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    loadSaleStatistics = LoadSaleStatisticsSpy();
  }

  void initPresenters() {
    sut = GetxHistoricGoalPresenter(
      loadSaleStatistics: loadSaleStatistics,
    );
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    now = DateTime.now();

    firebaseGoals = [
      GoalViewModel(
        EntityFactory.makeFirebaseGoalEntity(
          enterpriseId: homePresenter.selectedEnterpriseMock!.id!.toInt(),
          year: now.year,
          month: now.month,
        ),
      ),
    ];

    saleStatisticEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
  }

  void initMockSuccess() {
    loadSaleStatistics.mockGet(saleStatisticEntities);
    resumePresenter.goalsMock = firebaseGoals;
  }

  void initServices() {
    homePresenter = HomePresenterSpy();
    resumePresenter = ResumePresenterSpy();
    Get.put<HomePresenter>(homePresenter);
    Get.put<ResumePresenter>(resumePresenter);
  }

  setUp(() {
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }

    initServices();
    initEntities();
    initUsecases();
    initPresenters();
    initMockSuccess();
  });

  tearDown(() {
    Get.reset();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetSalesParams());
  });

  group("Load historic sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadHistoricSales(now.year);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleStatistics.mockGetError();

      await sut.loadHistoricSales(now.year);
    });
    test("Should emit correct values on select period previous 08/2025",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([
          null,
          UIError.custom("${R.string.msgHistoricGoalAvailableSince} 2025"),
        ]),
      );

      await sut
          .loadHistoricSales(faker.randomGenerator.integer(2024, min: 2000));
    });
    test("Should start the search from month 7 if year is 2025", () async {
      await sut.loadHistoricSales(2025);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: DateTime(2025, 7),
              endDate: DateTime(2025, 12, 31),
              groupByMonth: true,
              groupByYear: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          )).called(1);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: DateTime(2024, 8),
              endDate: DateTime(2024, 12, 31),
              groupByMonth: true,
              groupByYear: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          )).called(1);
    });

    test("Should search sales from current selected year if is not 2025",
        () async {
      final year = faker.randomGenerator.integer(2050, min: 2026);

      await sut.loadHistoricSales(year);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: DateTime(year),
              endDate: DateTime(year, 12, 31),
              groupByMonth: true,
              groupByYear: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          )).called(1);
    });

    test("Should get sales from the previous selected year", () async {
      await sut.loadHistoricSales(2026);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: DateTime(2025),
              endDate: DateTime(2025, 12, 31),
              groupByMonth: true,
              groupByYear: true,
              groupByEnterprise: true,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
            ),
          )).called(1);
    });
    test("Should update sale statistics correctly", () async {
      await sut
          .loadHistoricSales(faker.randomGenerator.integer(2050, min: 2025));

      expect(sut.selectedYearSalesStatistics, [
        ...saleStatisticEntities
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
        ...saleStatisticEntities
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel()),
      ]);
    });
  });

  group("Get goal value", () {
    test(
        "Should return the remote value if contains value with the same period and enterprise",
        () {
      final goalValue = sut.getGoalValue(now.year, now.month);

      expect(goalValue, firebaseGoals.first.goalEntity!.value);
    });
    test("Should return previous year + 5% if doesnt exists remote goal",
        () async {
      final enterpriseId = homePresenter.selectedEnterpriseMock!.id!.toInt();
      final sales = [
        EntityFactory.makeSaleStatisticEntity(
          enterpriseId: enterpriseId,
          year: now.year - 1,
          month: now.month,
        ),
        EntityFactory.makeSaleStatisticEntity(
          enterpriseId: enterpriseId,
          year: now.year - 1,
          month: now.month,
        ),
        EntityFactory.makeSaleStatisticEntity(
          enterpriseId: enterpriseId,
          year: now.year - 1,
          month: now.month,
        ),
      ];
      resumePresenter.goalsMock = []; //no goals
      loadSaleStatistics.mockGet(sales);

      await sut.loadHistoricSales(now.year);

      final goalValue = sut.getGoalValue(now.year, now.month);

      final salesViewModels = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();
      expect(
          goalValue,
          (salesViewModels.sumLiquidValue() *
                  1.05 *
                  2) //! *2 because load sales twice
              .toStringAsFixed(2)
              .toDouble());
    });
    test("Should return previous month + 5% if doesnt exists remote goal",
        () async {
      final enterpriseId = homePresenter.selectedEnterpriseMock!.id!.toInt();
      final sales = [
        EntityFactory.makeSaleStatisticEntity(
          enterpriseId: enterpriseId,
          year: now.year,
          month: now.month - 1,
        ),
        EntityFactory.makeSaleStatisticEntity(
          enterpriseId: enterpriseId,
          year: now.year,
          month: now.month - 1,
        ),
        EntityFactory.makeSaleStatisticEntity(
          enterpriseId: enterpriseId,
          year: now.year,
          month: now.month - 1,
        ),
      ];
      resumePresenter.goalsMock = []; //no goals
      loadSaleStatistics.mockGet(sales);

      await sut.loadHistoricSales(now.year);

      final goalValue = sut.getGoalValue(now.year, now.month);

      final salesViewModels = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();
      expect(
          goalValue,
          (salesViewModels.sumLiquidValue() *
                  1.05 *
                  2) //! *2 because load sales twice
              .toStringAsFixed(2)
              .toDouble());
    });
  });
}

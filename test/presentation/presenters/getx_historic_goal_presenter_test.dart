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

  late LoadSaleStatisticsSpy loadSaleStatistics;

  late List<SaleStatisticsEntity> saleStatisticEntities;
  late DateTime now;

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

    saleStatisticEntities = [
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
      EntityFactory.makeSaleStatisticEntity(),
    ];
    now = DateTime.now();
  }

  void initMockSuccess() {
    homePresenter.selectedEnterpriseMock =
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity())
            .toViewModel();
    loadSaleStatistics.mockGet(saleStatisticEntities);
  }

  void initServices() {
    homePresenter = HomePresenterSpy();
    Get.put<HomePresenter>(homePresenter);
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
    test("Should start the search from month 8 if year is 2025", () async {
      await sut.loadHistoricSales(2025);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: DateTime(2025, 8, 1),
              endDate: DateTime(2025, 12, 31),
              groupByMonth: true,
              enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
            ),
          )).called(1);
    });
    test("Should start the search from month 8 if year is 2025", () async {
      final year = faker.randomGenerator.integer(2024, min: 2000);

      await sut.loadHistoricSales(2025);

      verify(() => loadSaleStatistics.get(
            GetSaleStatisticsParams(
              startDate: DateTime(year, 1, 1),
              endDate: DateTime(year, 12, 31),
              groupByMonth: true,
              enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
            ),
          )).called(1);
    });
    test("Should update sale statistics correctly", () async {
      await sut
          .loadHistoricSales(faker.randomGenerator.integer(2050, min: 2025));

      expect(
        sut.saleStatistics,
        saleStatisticEntities
            .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
            .toList(),
      );
    });
  });
}

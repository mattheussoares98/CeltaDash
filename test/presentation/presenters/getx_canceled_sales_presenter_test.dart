import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxCanceledSalesPresenter sut;

  late HomePresenterSpy homePresenter;

  late EcLoadSaleMovementsSpy ecLoadSaleMovements;

  late List<SaleMovementEntity> saleMovementEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    ecLoadSaleMovements = EcLoadSaleMovementsSpy();
  }

  void initPresenters() {
    sut = GetxCanceledSalesPresenter(ecLoadSaleMovements: ecLoadSaleMovements);
    homePresenter = HomePresenterSpy();
  }

  void initEntities() {
    saleMovementEntities = [
      EntityFactory.makeEcSaleMovementEntity(),
      EntityFactory.makeEcSaleMovementEntity(),
      EntityFactory.makeEcSaleMovementEntity(),
    ];
  }

  void initMockSuccess() {
    ecLoadSaleMovements.mockGet(saleMovementEntities);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeGetEcSaleMovementParams());
  });

  group("Get sales", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getSales(homePresenter);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      ecLoadSaleMovements.mockGetError();

      await sut.getSales(homePresenter);
    });

    test("Should update sale movements correctly", () async {
      await sut.getSales(homePresenter);

      expect(
          sut.ecSaleMovements,
          saleMovementEntities
              .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
              .toList());
    });
    test("Should call ec load sale movements with correct params", () async {
      await sut.getSales(homePresenter);

      verify(() => ecLoadSaleMovements.get(
            GetEcSaleMovementParams(
              endDate: homePresenter.selectedDateMock,
              startDate: homePresenter.selectedDateMock,
              enterpriseIds: [
                homePresenter.selectedEnterpriseMock!.id!.toInt()
              ],
              onlyCancelled: true,
            ),
          )).called(1);
    });
  });
}

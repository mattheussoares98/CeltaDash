import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/data/usecases/usecases.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

void main() {
  late RemoteEcLoadSaleMovements sut;

  late HttpClientSpy httpClient;

  late GetEcSaleMovementParams params;
  late List<SaleMovementEntity> saleMovementEntities;

  WidgetsFlutterBinding.ensureInitialized();

  void initUsecases() {
    httpClient = HttpClientSpy();
  }

  void initPresenters() {
    sut = RemoteEcLoadSaleMovements(httpClient);
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    saleMovementEntities = [
      EntityFactory.makeEcSaleMovementEntity(),
      EntityFactory.makeEcSaleMovementEntity(),
      EntityFactory.makeEcSaleMovementEntity(),
    ];
    params = EntityFactory.makeGetEcSaleMovementParams();
  }

  void initMockSuccess() {
    httpClient.mockRequest({
      "collection": saleMovementEntities
          .map((e) => SaleMovementModel.fromEntity(e).toJson())
          .toList(),
      "totalRecords": 1,
      "recordsByPage": 100,
      "recordsOnThisPage": 1,
      "totalPages": 1,
      "actualPage": 1,
    });
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

  test("Should call httpClient with correct parameters", () async {
    await sut.get(params);

    verify(
      () => httpClient.request(
        url: "${EnterpriseBuilder.entity!.baseUrl!}/api/salemovements",
        method: "post",
        headers: {
          "user": EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
        body: {
          "enterpriseIds": params.EnterpriseIds,
          "dateHourOfBilling": {
            "startDate": params.StartDate.toIso8601String(),
            "endDate": params.EndDate.toIso8601String(),
          },
          "DocumentNumbers": params.DocumentNumbers,
          "OnlyCancelled": params.OnlyCancelled,
          "MountFiscalNoteType": params.MountFiscalNoteType,
          "MountCustomer": params.MountCustomer,
          "MountSeller": params.MountSeller,
          "MountProducts": params.MountProducts,
          "MountPaymentFinalizations": params.MountPaymentFinalizations,
          "ActualPage": params.ActualPage,
          "RecordsByPage": params.RecordsByPage,
        },
      ),
    ).called(1);
  });
  test(
      "Should call httpClient with correct parameters when pass only obligatory params",
      () async {
    final enterpriseIds = [faker.randomGenerator.integer(99)];
    final date = faker.date.dateTime();
    await sut.get(
      GetEcSaleMovementParams(
        EnterpriseIds: enterpriseIds,
        StartDate: date,
        EndDate: date,
      ),
    );

    verify(
      () => httpClient.request(
        url: "${EnterpriseBuilder.entity!.baseUrl!}/api/salemovements",
        method: "post",
        headers: {
          "user": EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
        body: {
          "enterpriseIds": enterpriseIds,
          "dateHourOfBilling": {
            "startDate": date.toIso8601String(),
            "endDate": date.toIso8601String(),
          },
          "DocumentNumbers": null,
          "OnlyCancelled": null,
          "MountFiscalNoteType": null,
          "MountCustomer": null,
          "MountSeller": null,
          "MountProducts": null,
          "MountPaymentFinalizations": null,
          "ActualPage": 1,
          "RecordsByPage": 100,
        },
      ),
    ).called(1);
  });

  test(
    "Should return list of SaleStatisticEntity when API wraps in searchParameters/results",
    () async {
      final list = await sut.get(params);

      expect(list, saleMovementEntities);
    },
  );
}

import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/data/usecases/usecases.dart';
import 'package:celta_plus/domain/entities/sale_movement_entity.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../../infra/mocks/mocks.dart';

void main() {
  late RemoteLoadSaleMovements sut;

  late HttpClientSpy httpClient;

  late DateTime startDate;
  late DateTime endDate;
  late bool groupByDay;
  late bool groupByEnterprise;
  late bool groupByHour;
  late bool groupByMonth;
  late bool groupByProduct;
  late bool groupByYear;
  late List<int> enterpriseIds;
  late List<SaleMovementEntity> saleMovementsEntitys;

  WidgetsFlutterBinding.ensureInitialized();

  void initUsecases() {
    httpClient = HttpClientSpy();
  }

  void initPresenters() {
    sut = RemoteLoadSaleMovements(httpClient);
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseEntity();
    saleMovementsEntitys = [
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
      EntityFactory.makeSaleMovementEntity(),
    ];
    startDate = faker.date.dateTime();
    endDate = faker.date.dateTime();
    groupByDay = faker.randomGenerator.boolean();
    groupByEnterprise = faker.randomGenerator.boolean();
    groupByHour = faker.randomGenerator.boolean();
    groupByMonth = faker.randomGenerator.boolean();
    groupByProduct = faker.randomGenerator.boolean();
    groupByYear = faker.randomGenerator.boolean();
    enterpriseIds = [
      faker.randomGenerator.integer(10),
      faker.randomGenerator.integer(10),
      faker.randomGenerator.integer(10),
    ];
  }

  void initMockSuccess() {
    httpClient.mockRequest(
      saleMovementsEntitys
          .map((e) => SaleMovementModel.fromEntity(e).toJson())
          .toList(),
    );
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });

  test("Should call httpClient with correct parameters", () async {
    await sut.get(
      startDate: startDate,
      endDate: endDate,
      enterpriseIds: enterpriseIds,
      groupByDay: groupByDay,
      groupByEnterprise: groupByEnterprise,
      groupByHour: groupByHour,
      groupByMonth: groupByMonth,
      groupByProduct: groupByProduct,
      groupByYear: groupByYear,
    );

    verify(
      () => httpClient.request(
        url:
            "${EnterpriseBuilder.entity!.url!}/api/salemovements/getstatistics",
        method: "post",
        body: {
          "period": {
            "startDate": startDate.toIso8601String(),
            "endDate": endDate.toIso8601String(),
          },
          "groupByEnterprise": groupByEnterprise,
          "groupByYear": groupByYear,
          "groupByMonth": groupByMonth,
          "groupByDay": groupByDay,
          "groupByHour": groupByHour,
          "groupByProduct": groupByProduct,
          "enterpriseIds": enterpriseIds,
        },
      ),
    ).called(1);
  });

  //TODO create other tests
}

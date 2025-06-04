import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/data/usecases/usecases.dart';
import 'package:celta_dash/domain/entities/sale_movement_entity.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

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
  late bool groupByProductDepartment;
  late bool groupByProductSection;
  late bool groupByPaymentFinalization;
  late bool groupByPaymentModality;
  late bool groupByCashierOperator;
  late bool groupBySeller;
  late int topCount;
  late List<int> enterpriseIds;
  late List<SaleMovementEntity> saleMovementsEntitys;

  WidgetsFlutterBinding.ensureInitialized();

  void initUsecases() {
    httpClient = HttpClientSpy();
  }

  void initPresenters() {
    sut = RemoteLoadSaleMovements(httpClient);
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
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
    groupByProductDepartment = faker.randomGenerator.boolean();
    groupByProductSection = faker.randomGenerator.boolean();
    groupByPaymentFinalization = faker.randomGenerator.boolean();
    groupByPaymentModality = faker.randomGenerator.boolean();
    groupByCashierOperator = faker.randomGenerator.boolean();
    groupBySeller = faker.randomGenerator.boolean();
    enterpriseIds = [
      faker.randomGenerator.integer(10),
      faker.randomGenerator.integer(10),
      faker.randomGenerator.integer(10),
    ];
    topCount = faker.randomGenerator.integer(100);
  }

  void initMockSuccess() {
    final searchParameters = {
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
      "groupByProductDepartment": groupByProductDepartment,
      "groupByProductSection": groupByProductSection,
      "groupByPaymentFinalization": groupByPaymentFinalization,
      "groupByPaymentModality": groupByPaymentModality,
      "groupBySeller": groupBySeller,
      "user": {"id": 274, "name": "CELTABSPDV"},
    };

    final results = saleMovementsEntitys
        .map((e) => SaleMovementModel.fromEntity(e).toJson())
        .toList();

    httpClient.mockRequest({
      "searchParameters": searchParameters,
      "results": results,
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
    await sut.get(
      startDate: startDate,
      endDate: endDate,
      enterpriseIds: enterpriseIds,
      groupByEnterprise: groupByEnterprise,
      groupByYear: groupByYear,
      groupByMonth: groupByMonth,
      groupByDay: groupByDay,
      groupByHour: groupByHour,
      groupByProduct: groupByProduct,
      groupByProductDepartment: groupByProductDepartment,
      groupByProductSection: groupByProductSection,
      groupByPaymentFinalization: groupByPaymentFinalization,
      groupByPaymentModality: groupByPaymentModality,
      groupByCashierOperator: groupByCashierOperator,
      groupBySeller: groupBySeller,
      topCount: topCount,
    );

    verify(
      () => httpClient.request(
        url:
            "${EnterpriseBuilder.entity!.baseUrl!}/api/salemovements/getstatistics",
        method: "post",
        headers: {
          "user": EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
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
          "groupByProductDepartment": groupByProductDepartment,
          "groupByProductSection": groupByProductSection,
          "groupByPaymentFinalization": groupByPaymentFinalization,
          "groupByPaymentModality": groupByPaymentModality,
          "groupByCashierOperator": groupByCashierOperator,
          "groupBySeller": groupBySeller,
          "enterpriseIds": enterpriseIds,
          "topCount": topCount,
        },
      ),
    ).called(1);
  });

  test(
    "Should return list of SaleMovementEntity when API wraps in searchParameters/results",
    () async {
      final list = await sut.get(
        startDate: startDate,
        endDate: endDate,
        enterpriseIds: enterpriseIds,
        groupByEnterprise: groupByEnterprise,
        groupByYear: groupByYear,
        groupByMonth: groupByMonth,
        groupByDay: groupByDay,
        groupByHour: groupByHour,
        groupByProduct: groupByProduct,
        groupByProductDepartment: groupByProductDepartment,
        groupByProductSection: groupByProductSection,
        groupByPaymentFinalization: groupByPaymentFinalization,
        groupByPaymentModality: groupByPaymentModality,
        groupBySeller: groupBySeller,
      );

      expect(list, saleMovementsEntitys);
    },
  );
}

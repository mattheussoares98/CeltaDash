import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:celta_dash/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_dash/features/buy_movement/data/models/models.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient httpClient;
  late BuyMovementDatasource sut;
  late EcParams ecParams;
  late SearchBuyMovementDataParamsEntity params;
  late Map requestBody;

  setUp(() {
    httpClient = MockHttpClient();
    sut = BuyMovementDatasource(httpClient);
    ecParams = EntityFactory.makeEcParams();
    params = BuyMovementEntityFactory.makeSearchParams(
      enterpriseCodes: const [10],
      startDate: DateTime(2026, 8, 17),
      endDate: DateTime(2026, 8, 18),
      periodGrouping: BuyMovementPeriodGrouping.day,
      groupByEnterprise: false,
      groupByProduct: false,
      groupBySupplier: false,
    );
    requestBody = SearchBuyMovementDataModel.fromEntity(params).toJson();
  });

  group('BuyMovementDatasource.getData', () {
    test('sends the exact Commerce request', () async {
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: requestBody,
        ),
      ).thenAnswer((_) async => <String, dynamic>{});

      await sut.getData(params: params, ecParams: ecParams);

      expect(requestBody, {
        'EnterpriseCodes': [10],
        'Period': {
          'StartDate': '2026-08-17T00:00:00.000',
          'EndDate': '2026-08-18T00:00:00.000',
        },
        'PeriodGrouping': 2,
        'GroupByEnterprise': false,
        'GroupByProduct': false,
        'GroupBySupplier': false,
      });
      verify(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: SearchBuyMovementDataModel.fromEntity(params).toJson(),
        ),
      ).called(1);
    });

    test('parses the Commerce response model', () async {
      final expected = BuyMovementDataResponseModel.fromEntity(
        BuyMovementEntityFactory.makeResponseEntity(searchParameters: params),
      );
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: requestBody,
        ),
      ).thenAnswer((_) async => expected.toJson());

      final result = await sut.getData(params: params, ecParams: ecParams);

      expect(result, expected);
    });

    test('sends the exact product-grouped Commerce request', () async {
      final productParams = BuyMovementEntityFactory.makeSearchParams(
        enterpriseCodes: const [10],
        startDate: DateTime(2026, 8),
        endDate: DateTime(2026, 8, 31),
        annulPeriodGrouping: true,
        groupByEnterprise: false,
        groupByProduct: true,
        groupBySupplier: false,
        productName: 'coffee',
        topCount: 25,
      );
      final productBody = SearchBuyMovementDataModel.fromEntity(
        productParams,
      ).toJson();
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: productBody,
        ),
      ).thenAnswer((_) async => <String, dynamic>{});

      await sut.getData(params: productParams, ecParams: ecParams);

      expect(productBody, {
        'EnterpriseCodes': [10],
        'Period': {
          'StartDate': '2026-08-01T00:00:00.000',
          'EndDate': '2026-08-31T00:00:00.000',
        },
        'GroupByEnterprise': false,
        'GroupByProduct': true,
        'GroupBySupplier': false,
        'ProductName': 'coffee',
        'TopCount': 25,
      });
      verify(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: productBody,
        ),
      ).called(1);
    });

    test('parses PascalCase fields and decimal values', () async {
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: requestBody,
        ),
      ).thenAnswer(
        (_) async => {
          'Results': [
            {
              'EnterpriseCode': 10,
              'Date': '2026-08-17T00:00:00',
              'Product': {
                'Code': 20,
                'PackingCode': 2,
                'Name': 'Coffee',
                'Quantity': 3.5,
              },
              'Supplier': {'Code': 30, 'Name': 'Supplier'},
              'TotalValue': 125.75,
            },
          ],
        },
      );

      final result = await sut.getData(params: params, ecParams: ecParams);
      final row = result.results.single;

      expect(row.enterpriseCode, 10);
      expect(row.product?.priceLookupCode, 2);
      expect(row.product?.quantity, 3.5);
      expect(row.supplier?.code, 30);
      expect(row.totalValue, 125.75);
    });

    test('parses camelCase fields with null grouping values', () async {
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: requestBody,
        ),
      ).thenAnswer(
        (_) async => {
          'results': [
            {
              'enterpriseCode': null,
              'date': '2026-08-17T00:00:00',
              'product': null,
              'supplier': null,
              'totalValue': 10.25,
            },
          ],
        },
      );

      final result = await sut.getData(params: params, ecParams: ecParams);
      final row = result.results.single;

      expect(row.enterpriseCode, isNull);
      expect(row.product, isNull);
      expect(row.supplier, isNull);
      expect(row.totalValue, 10.25);
    });

    test('parses an empty result set', () async {
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: requestBody,
        ),
      ).thenAnswer((_) async => {'Results': <Map>[]});

      final result = await sut.getData(params: params, ecParams: ecParams);

      expect(result.results, isEmpty);
    });

    test('sends and parses an enterprise-grouped request', () async {
      final groupParams = BuyMovementEntityFactory.makeSearchParams(
        enterpriseCodes: const [10, 20],
        startDate: DateTime(2026, 8, 17),
        endDate: DateTime(2026, 8, 17),
        periodGrouping: BuyMovementPeriodGrouping.day,
        groupByEnterprise: true,
        groupByProduct: false,
        groupBySupplier: false,
      );
      final expected = BuyMovementDataResponseModel.fromEntity(
        BuyMovementEntityFactory.makeResponseEntity(
          searchParameters: groupParams,
          results: [
            BuyMovementEntityFactory.makeDataRowEntity(
              enterpriseCode: 20,
              withProduct: false,
              withSupplier: false,
              totalValue: 125.50,
            ),
          ],
        ),
      );
      final groupRequestBody = SearchBuyMovementDataModel.fromEntity(
        groupParams,
      ).toJson();
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: groupRequestBody,
        ),
      ).thenAnswer((_) async => expected.toJson());

      final result = await sut.getData(params: groupParams, ecParams: ecParams);

      expect(groupRequestBody['GroupByEnterprise'], isTrue);
      expect(result.results.single.enterpriseCode, 20);
      expect(result.results.single.totalValue, 125.50);
      verify(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: groupRequestBody,
        ),
      ).called(1);
    });

    test('propagates HTTP failures', () async {
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/BuyMovements/GetData',
          method: 'post',
          headers: ecParams.toHeaders(),
          body: requestBody,
        ),
      ).thenThrow(HttpError.serverError);

      final call = sut.getData(params: params, ecParams: ecParams);

      expect(call, throwsA(HttpError.serverError));
    });
  });
}

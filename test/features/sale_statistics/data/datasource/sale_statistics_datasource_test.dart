// test/features/sale_statistics/data/datasource/sale_statistics_datasource_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/sale_statistics/data/datasource/datasource.dart';
import 'package:celta_dash/features/sale_statistics/data/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';

import '../../../../domain/mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late SaleStatisticsDatasource sut;
  late EcParams tEcParams;
  late GetSaleStatisticsParams tParams;
  late SaleStatisticsEntity tEntity;
  late SaleStatisticsModel tModel;

  setUp(() {
    mockHttpClient = MockHttpClient();
    sut = SaleStatisticsDatasource(mockHttpClient);
    tEcParams = EntityFactory.makeEcParams();
    tParams = EntityFactory.makeGetSalesParams();
    tEntity = EntityFactory.makeSaleStatisticEntity();
    tModel = SaleStatisticsModel.fromEntity(tEntity);
  });

  group('SaleStatisticsDatasource.getSaleStatistics', () {
    test('should call httpClient with correct url, method, headers and body', () async {
      when(() => mockHttpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => {'results': []});

      await sut.getSaleStatistics(params: tParams, ecParams: tEcParams);

      verify(() => mockHttpClient.request(
            url: '${tEcParams.url}/api/salemovements/getstatistics',
            method: 'post',
            headers: tEcParams.toHeaders(),
            body: tParams.toBody(),
          )).called(1);
    });

    test('should return list of SaleStatisticsModel when request succeeds', () async {
      when(() => mockHttpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => {
            'results': [tModel.toJson()]
          });

      final result = await sut.getSaleStatistics(params: tParams, ecParams: tEcParams);

      expect(result, isA<List<SaleStatisticsModel>>());
      expect(result.length, 1);
      expect(result.first, tModel);
    });

    test('should throw DomainError.unexpected when httpClient throws HttpError', () async {
      when(() => mockHttpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(HttpError.serverError);

      final call = sut.getSaleStatistics(params: tParams, ecParams: tEcParams);

      expect(() => call, throwsA(DomainError.unexpected));
    });
  });
}

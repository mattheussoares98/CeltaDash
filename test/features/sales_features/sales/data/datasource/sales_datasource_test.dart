import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:celta_dash/features/sales_features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales_features/sales/domain/domain.dart';
import 'package:celta_dash/features/login/login.dart';
import 'package:celta_dash/features/sales_features/sales/data/datasource/datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient httpClient;
  late SalesDatasource datasource;
  late EcParams ecParams;
  late GetSaleMovementParams params;
  late SaleMovementModel model;

  setUp(() {
    httpClient = MockHttpClient();
    datasource = SalesDatasource(httpClient);
    ecParams = EntityFactory.makeEcParams();
    params = EntityFactory.makeGetSaleMovementParams();
    model = SaleMovementModel.fromEntity(
      EntityFactory.makeSaleMovementEntity(),
    );
  });

  test('posts the sale movement request and maps its response', () async {
    when(
      () => httpClient.request(
        url: '${ecParams.url}/api/salemovements',
        method: 'post',
        headers: ecParams.toHeaders(),
        body: params.toBody(),
      ),
    ).thenAnswer((_) async => model.toJson());

    final result = await datasource.getSaleMovements(
      params: params,
      ecParams: ecParams,
    );

    expect(result, model);
    verify(
      () => httpClient.request(
        url: '${ecParams.url}/api/salemovements',
        method: 'post',
        headers: ecParams.toHeaders(),
        body: params.toBody(),
      ),
    ).called(1);
  });

  test('propagates request failures', () async {
    when(
      () => httpClient.request(
        url: '${ecParams.url}/api/salemovements',
        method: 'post',
        headers: ecParams.toHeaders(),
        body: params.toBody(),
      ),
    ).thenThrow(HttpError.serverError);

    expect(
      () => datasource.getSaleMovements(params: params, ecParams: ecParams),
      throwsA(HttpError.serverError),
    );
  });
}

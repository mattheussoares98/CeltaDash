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
    params = BuyMovementEntityFactory.makeSearchParams();
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

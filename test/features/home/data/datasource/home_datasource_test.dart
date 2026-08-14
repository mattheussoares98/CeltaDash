import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockHttpClient httpClient;
  late HomeDatasource datasource;

  setUp(() {
    httpClient = MockHttpClient();
    datasource = HomeDatasource(httpClient);
  });

  test(
    'getEnterprises sends the EC URL and headers and maps the response',
    () async {
      final ecParams = EntityFactory.makeEcParams();
    final entity = HomeEntityFactory.makeHomeEnterpriseEntity();
      final json = BSFEnterpriseModel.fromEntity(entity).toJson();
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/enterprises',
          method: 'get',
          headers: ecParams.toHeaders(),
        ),
      ).thenAnswer((_) async => [json]);

      final result = await datasource.getEnterprises(ecParams);

      expect(result, [isA<BSFEnterpriseModel>()]);
      expect(result.single.toJson(), json);
      verify(
        () => httpClient.request(
          url: '${ecParams.url}/api/enterprises',
          method: 'get',
          headers: ecParams.toHeaders(),
        ),
      ).called(1);
    },
  );

  test(
    'getEnterprises maps HTTP failures to the standard domain error',
    () async {
      final ecParams = EntityFactory.makeEcParams();
      when(
        () => httpClient.request(
          url: '${ecParams.url}/api/enterprises',
          method: 'get',
          headers: ecParams.toHeaders(),
        ),
      ).thenThrow(HttpError.serverError);

      expect(
        () => datasource.getEnterprises(ecParams),
        throwsA(DomainError.unexpected),
      );
    },
  );
}

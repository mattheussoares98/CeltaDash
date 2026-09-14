import 'package:celta_dash/core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../infrastructure/mocks/mocks.dart';

void main() {
  test('getReleasedAtUtc sends the EC URL and headers', () async {
    final httpClient = HttpClientSpy();
    final datasource = EcReleaseDatasource(httpClient);
    final params = EntityFactory.makeEcParams();
    const releasedAtUtc = '2026-09-14T17:00:51.5948770Z';
    when(
      () => httpClient.request(
        url: '${params.url}/api/Release',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenAnswer((_) async => releasedAtUtc);

    final result = await datasource.getReleasedAtUtc(params);

    expect(result, releasedAtUtc);
    verify(
      () => httpClient.request(
        url: '${params.url}/api/Release',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
  });
}

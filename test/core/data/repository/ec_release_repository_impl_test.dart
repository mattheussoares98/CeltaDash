import 'package:celta_dash/core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../mocks/mock_ec_release_datasource.dart';

void main() {
  test('getReleasedAtUtc parses the datasource value as UTC', () async {
    final datasource = MockEcReleaseDatasource();
    final repository = EcReleaseRepositoryImpl(datasource);
    final params = EntityFactory.makeEcParams();
    const releasedAtUtc = '2026-09-14T14:00:51.5948770-03:00';
    when(
      () => datasource.getReleasedAtUtc(params),
    ).thenAnswer((_) async => releasedAtUtc);

    final result = await repository.getReleasedAtUtc(params);

    expect(result, DateTime.parse('2026-09-14T17:00:51.594877Z'));
    verify(() => datasource.getReleasedAtUtc(params)).called(1);
  });
}

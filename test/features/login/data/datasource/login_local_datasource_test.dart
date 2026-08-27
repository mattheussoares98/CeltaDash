import 'package:celta_dash/features/login/data/data.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockAppStorage storage;
  late LoginLocalDatasource datasource;

  setUp(() {
    storage = MockAppStorage();
    datasource = LoginLocalDatasource(storage);
  });

  test('loadLastEnterprise maps the saved enterprise', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    final json = FirebaseEnterpriseModel.fromEntity(enterprise).toJson();
    when(
      () => storage.get(DatabaseKeys.enterprise.name),
    ).thenAnswer((_) async => json);

    expect(await datasource.loadLastEnterprise(), enterprise);
    verify(() => storage.get(DatabaseKeys.enterprise.name)).called(1);
  });

  test('loadLastEnterprise returns null when storage is empty', () async {
    when(
      () => storage.get(DatabaseKeys.enterprise.name),
    ).thenAnswer((_) async => null);

    expect(await datasource.loadLastEnterprise(), isNull);
  });
}

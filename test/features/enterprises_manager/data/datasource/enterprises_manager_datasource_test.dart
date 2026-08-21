import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/features/enterprises_manager/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockAppStorage storage;
  late EnterprisesManagerDatasource datasource;
  late FirebaseEnterpriseModel enterpriseModel;

  setUp(() {
    storage = MockAppStorage();
    datasource = EnterprisesManagerDatasource(storage);
    enterpriseModel = FirebaseEnterpriseModel.fromEntity(
      EntityFactory.makeFirebaseEnterpriseEntity(),
    );
  });

  test(
    'loadEnterprises reads the legacy allEnterprises key and JSON',
    () async {
      when(
        () => storage.get('allEnterprises'),
      ).thenAnswer((_) async => [enterpriseModel.toJson()]);

      final result = await datasource.loadEnterprises();
      expect(result.map((model) => model.toJson()), [enterpriseModel.toJson()]);
      verify(() => storage.get('allEnterprises')).called(1);
    },
  );

  test(
    'loadEnterprises returns empty when the legacy key has no list',
    () async {
      when(() => storage.get('allEnterprises')).thenAnswer((_) async => null);

      expect(await datasource.loadEnterprises(), isEmpty);
      verify(() => storage.get('allEnterprises')).called(1);
    },
  );

  test('loadSelectedEnterprise reads the legacy enterprise key', () async {
    when(
      () => storage.get('enterprise'),
    ).thenAnswer((_) async => enterpriseModel.toJson());

    expect(
      (await datasource.loadSelectedEnterprise())?.toJson(),
      enterpriseModel.toJson(),
    );
    verify(() => storage.get('enterprise')).called(1);
  });

  test(
    'loadSelectedEnterprise returns null for an empty legacy value',
    () async {
      when(() => storage.get('enterprise')).thenAnswer((_) async => '');

      expect(await datasource.loadSelectedEnterprise(), isNull);
    },
  );

  test('saveEnterprises keeps the legacy key and JSON shape', () async {
    final json = enterpriseModel.toJson();
    when(() => storage.put('allEnterprises', [json])).thenAnswer((_) async {});

    await datasource.saveEnterprises([enterpriseModel]);

    verify(() => storage.put('allEnterprises', [json])).called(1);
  });

  test('saveSelectedEnterprise keeps the legacy key and JSON shape', () async {
    final json = enterpriseModel.toJson();
    when(() => storage.put('enterprise', json)).thenAnswer((_) async {});

    await datasource.saveSelectedEnterprise(enterpriseModel);

    verify(() => storage.put('enterprise', json)).called(1);
  });
}

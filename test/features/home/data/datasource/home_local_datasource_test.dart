import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockAppStorage storage;
  late HomeLocalDatasource datasource;

  setUp(() {
    storage = MockAppStorage();
    datasource = HomeLocalDatasource(storage);
  });

  test('loadAppMode returns the saved mode', () async {
    when(
      () => storage.get('appMode'),
    ).thenAnswer((_) async => AppMode.financialTitles.name);

    expect(await datasource.loadAppMode(), AppMode.financialTitles);
    verify(() => storage.get('appMode')).called(1);
  });

  test('loadAppMode falls back to sales for an invalid value', () async {
    when(() => storage.get('appMode')).thenAnswer((_) async => 'invalid');

    expect(await datasource.loadAppMode(), AppMode.sales);
  });

  test('saveAppMode persists the enum name', () async {
    when(
      () => storage.put('appMode', AppMode.financialTitles.name),
    ).thenAnswer((_) async {});

    await datasource.saveAppMode(AppMode.financialTitles);

    verify(
      () => storage.put('appMode', AppMode.financialTitles.name),
    ).called(1);
  });

  test('loadActiveEnterprise maps the saved core model', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    final json = FirebaseEnterpriseModel.fromEntity(enterprise).toJson();
    when(() => storage.get('enterprise')).thenAnswer((_) async => json);

    expect(await datasource.loadActiveEnterprise(), enterprise);
  });

  test('loadActiveEnterprise returns null when storage is empty', () async {
    when(() => storage.get('enterprise')).thenAnswer((_) async => null);

    expect(await datasource.loadActiveEnterprise(), isNull);
  });
}

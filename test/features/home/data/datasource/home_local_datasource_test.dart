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

  test('loadAppMode returns a legacy saved mode', () async {
    when(
      () => storage.get('appMode'),
    ).thenAnswer((_) async => AppMode.financialTitles.name);

    expect(await datasource.loadAppMode(), AppMode.financialTitles);
    verify(() => storage.get('appMode')).called(1);
  });

  test('loadAppMode returns the saved buy movements mode', () async {
    when(
      () => storage.get('appMode'),
    ).thenAnswer((_) async => AppMode.buyMovements.name);

    expect(await datasource.loadAppMode(), AppMode.buyMovements);
    verify(() => storage.get('appMode')).called(1);
  });

  test('loadAppMode falls back to sales for an invalid value', () async {
    when(() => storage.get('appMode')).thenAnswer((_) async => 'invalid');

    expect(await datasource.loadAppMode(), AppMode.sales);
  });

  test('saveAppMode persists the enum name', () async {
    when(
      () => storage.put('appMode', AppMode.buyMovements.name),
    ).thenAnswer((_) async {});

    await datasource.saveAppMode(AppMode.buyMovements);

    verify(() => storage.put('appMode', AppMode.buyMovements.name)).called(1);
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

  test('logout preserves labels and removes credentials and caches', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    final json = FirebaseEnterpriseModel.fromEntity(enterprise).toJson();
    final loggedOutEnterprise = enterprise.copyWith(
      bsUser: enterprise.bsUser?.copyWith(
        annulAccessKey: true,
        annulCrossIdentity_Usuario: true,
      ),
      annulBaseUrl: true,
      annulFirebaseId: true,
      annulFirebaseSubEnterprises: true,
    );
    final loggedOutJson = FirebaseEnterpriseModel.fromEntity(
      loggedOutEnterprise,
    ).toJson();
    when(() => storage.get('enterprise')).thenAnswer((_) async => json);
    when(
      () => storage.put('enterprise', loggedOutJson),
    ).thenAnswer((_) async {});
    when(() => storage.delete('allEnterprises')).thenAnswer((_) async {});

    await datasource.logout();

    verify(() => storage.put('enterprise', loggedOutJson)).called(1);
    verify(() => storage.delete('allEnterprises')).called(1);
  });

  test('logout clears storage when no active enterprise exists', () async {
    when(() => storage.get('enterprise')).thenAnswer((_) async => null);
    when(() => storage.delete('enterprise')).thenAnswer((_) async {});
    when(() => storage.delete('allEnterprises')).thenAnswer((_) async {});

    await datasource.logout();

    verify(() => storage.delete('enterprise')).called(1);
    verify(() => storage.delete('allEnterprises')).called(1);
  });
}

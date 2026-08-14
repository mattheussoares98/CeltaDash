import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockHomeDatasource remoteDatasource;
  late MockHomeLocalDatasource localDatasource;
  late HomeRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockHomeDatasource();
    localDatasource = MockHomeLocalDatasource();
    repository = HomeRepositoryImpl(remoteDatasource, localDatasource);
  });

  test('getEnterprises converts datasource models into entities', () async {
    final ecParams = EntityFactory.makeEcParams();
    final entity = HomeEntityFactory.makeHomeEnterpriseEntity(enabled: false);
    final model = BSFEnterpriseModel.fromEntity(entity);
    when(
      () => remoteDatasource.getEnterprises(ecParams),
    ).thenAnswer((_) async => [model]);

    expect(await repository.getEnterprises(ecParams), [entity]);
    verify(() => remoteDatasource.getEnterprises(ecParams)).called(1);
  });

  test('loadAppMode delegates to the local datasource', () async {
    when(
      () => localDatasource.loadAppMode(),
    ).thenAnswer((_) async => AppMode.sales);

    expect(await repository.loadAppMode(), AppMode.sales);
    verify(() => localDatasource.loadAppMode()).called(1);
  });

  test('saveAppMode delegates to the local datasource', () async {
    when(
      () => localDatasource.saveAppMode(AppMode.financialTitles),
    ).thenAnswer((_) async {});

    await repository.saveAppMode(AppMode.financialTitles);

    verify(
      () => localDatasource.saveAppMode(AppMode.financialTitles),
    ).called(1);
  });

  test('loadActiveEnterprise delegates to the local datasource', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    when(
      () => localDatasource.loadActiveEnterprise(),
    ).thenAnswer((_) async => enterprise);

    expect(await repository.loadActiveEnterprise(), enterprise);
    verify(() => localDatasource.loadActiveEnterprise()).called(1);
  });

  test('logout delegates to the local datasource', () async {
    when(() => localDatasource.logout()).thenAnswer((_) async {});

    await repository.logout();

    verify(() => localDatasource.logout()).called(1);
  });
}

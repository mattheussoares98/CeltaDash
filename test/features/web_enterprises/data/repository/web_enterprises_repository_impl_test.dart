import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockWebEnterprisesDatasource datasource;
  late WebEnterprisesRepositoryImpl repository;

  setUp(() {
    datasource = MockWebEnterprisesDatasource();
    repository = WebEnterprisesRepositoryImpl(datasource);
  });

  test('getEnterprises forwards the datasource result', () async {
    final enterprises = [EntityFactory.makeFirebaseEnterpriseEntity()];
    final models = enterprises.map(FirebaseEnterpriseModel.fromEntity).toList();
    when(datasource.getEnterprises).thenAnswer((_) async => models);

    expect(await repository.getEnterprises(), enterprises);
    verify(datasource.getEnterprises).called(1);
  });

  test('getAnalytics forwards the period and result', () async {
    final period = DateTime(2026, 8);
    final analytics = [WebEnterprisesEntityFactory.makeWebAnalyticsEntity()];
    final models = analytics.map(WebAnalyticsModel.fromEntity).toList();
    when(() => datasource.getAnalytics(period)).thenAnswer((_) async => models);

    expect(await repository.getAnalytics(period), analytics);
    verify(() => datasource.getAnalytics(period)).called(1);
  });

  test('createEnterprise authenticates, loads CNPJs, and persists', () async {
    final params = CreateWebEnterpriseParams(
      baseUrl: faker.internet.httpUrl(),
      enterpriseName: faker.company.name(),
      user: faker.person.name(),
      password: faker.internet.password(),
    );
    final accessKey = faker.guid.guid();
    final user = WebEnterpriseBsUserModel(
      name: params.user,
      accessKey: accessKey,
      crossIdentityUsuario: faker.guid.guid(),
    );
    final candidate = WebEnterpriseCandidateModel(
      id: faker.randomGenerator.integer(100),
      name: faker.company.name(),
      personalizedCode: faker.guid.guid(),
      cnpj: '12.345.678/0001-90',
    );
    when(() => datasource.authenticateBs(params)).thenAnswer((_) async => user);
    when(
      () => datasource.getCandidateEnterprises(
        baseUrl: params.normalizedBaseUrl,
        user: params.user,
        accessKey: accessKey,
      ),
    ).thenAnswer((_) async => [candidate]);
    final expectedEntity = FirebaseEnterpriseEntity(
      baseUrl: params.normalizedBaseUrl,
      enterpriseName: params.normalizedEnterpriseName,
      bsUser: null,
      firebaseSubEnterprises: [candidate.toEntity()],
      firebaseId: params.normalizedEnterpriseName,
    );
    final expectedModel = FirebaseEnterpriseModel.fromEntity(expectedEntity);
    when(
      () => datasource.createEnterprise(expectedModel),
    ).thenAnswer((_) async {});

    final result = await repository.createEnterprise(params);

    expect(result, expectedEntity);
    verify(() => datasource.createEnterprise(expectedModel)).called(1);
  });

  test('updateEnterprise converts the entity and forwards the model', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity().copyWith(
      annulBsUser: true,
    );
    final model = FirebaseEnterpriseModel.fromEntity(enterprise);
    when(() => datasource.updateEnterprise(model)).thenAnswer((_) async {});

    await repository.updateEnterprise(enterprise);

    verify(() => datasource.updateEnterprise(model)).called(1);
  });
}

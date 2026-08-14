// test/features/login/domain/repository/login_repository_impl_test.dart
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/login/login.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

class MockLoginEnterpriseDatasource extends Mock
    implements IFirebaseLoginEnterpriseDatasource {}

class MockLoginBsAuthDatasource extends Mock
    implements ILoginBsAuthDatasource {}

void main() {
  late MockLoginEnterpriseDatasource mockEnterpriseDatasource;
  late MockLoginBsAuthDatasource mockBsAuthDatasource;
  late MockLoginLocalDatasource mockLocalDatasource;
  late LoginRepositoryImpl repository;

  final tEnterpriseEntity = EntityFactory.makeFirebaseEnterpriseEntity();
  final tEnterpriseModel = FirebaseEnterpriseModel.fromEntity(
    tEnterpriseEntity,
  );
  final tBsUserEntity = EntityFactory.makeBsUserEntity();
  final tBsUserModel = BsUserModel.fromEntity(tBsUserEntity);

  final tParams = LoginParams(
    enterpriseName: tEnterpriseEntity.enterpriseName!,
    user: tBsUserEntity.name!,
    password: faker.internet.password(),
  );

  setUp(() {
    mockEnterpriseDatasource = MockLoginEnterpriseDatasource();
    mockBsAuthDatasource = MockLoginBsAuthDatasource();
    mockLocalDatasource = MockLoginLocalDatasource();
    repository = LoginRepositoryImpl(
      enterpriseDatasource: mockEnterpriseDatasource,
      bsAuthDatasource: mockBsAuthDatasource,
      localDatasource: mockLocalDatasource,
    );
  });

  test(
    'should return FirebaseEnterpriseEntity when datasources succeed',
    () async {
      when(
        () => mockEnterpriseDatasource.getEnterpriseConfig(
          enterpriseName: tParams.enterpriseName,
        ),
      ).thenAnswer((_) async => tEnterpriseModel);

      when(
        () => mockBsAuthDatasource.authenticateBs(
          user: tParams.user,
          password: tParams.password,
          url: tEnterpriseModel.baseUrl!,
        ),
      ).thenAnswer((_) async => tBsUserModel);

      final result = await repository.login(tParams);

      expect(result.enterpriseName, tParams.enterpriseName);
      expect(result.baseUrl, tEnterpriseModel.baseUrl);
      expect(result.bsUser?.name, tBsUserModel.name);
      expect(result.bsUser?.AccessKey, tBsUserModel.accessKey);

      verify(
        () => mockEnterpriseDatasource.getEnterpriseConfig(
          enterpriseName: tParams.enterpriseName,
        ),
      ).called(1);
      verify(
        () => mockBsAuthDatasource.authenticateBs(
          user: tParams.user,
          password: tParams.password,
          url: tEnterpriseModel.baseUrl!,
        ),
      ).called(1);
    },
  );

  test('should rethrow error when enterprise datasource fails', () async {
    when(
      () => mockEnterpriseDatasource.getEnterpriseConfig(
        enterpriseName: tParams.enterpriseName,
      ),
    ).thenThrow(DomainError.enterpriseNotFound);

    expect(
      () => repository.login(tParams),
      throwsA(DomainError.enterpriseNotFound),
    );
  });

  test('loadLastLogin delegates to the local datasource', () async {
    when(
      () => mockLocalDatasource.loadLastEnterprise(),
    ).thenAnswer((_) async => tEnterpriseEntity);

    expect(await repository.loadLastLogin(), tEnterpriseEntity);
    verify(() => mockLocalDatasource.loadLastEnterprise()).called(1);
  });
}

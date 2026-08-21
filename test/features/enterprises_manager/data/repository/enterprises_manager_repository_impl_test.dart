import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/enterprises_manager/data/data.dart';
import 'package:celta_dash/features/enterprises_manager/domain/domain.dart';
import 'package:celta_dash/features/login/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../login/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockEnterprisesManagerDatasource datasource;
  late MockLoginRepository loginRepository;
  late EnterprisesManagerRepositoryImpl repository;
  late FirebaseEnterpriseModel enterpriseModel;
  late AddEnterpriseParams addParams;

  setUp(() {
    datasource = MockEnterprisesManagerDatasource();
    loginRepository = MockLoginRepository();
    repository = EnterprisesManagerRepositoryImpl(
      datasource: datasource,
      loginRepository: loginRepository,
    );
    enterpriseModel = FirebaseEnterpriseModel.fromEntity(
      EntityFactory.makeFirebaseEnterpriseEntity(),
    );
    addParams = EntityFactory.makeAddEnterpriseParams();
  });

  test('loadEnterprises converts shared models to entities', () async {
    when(
      () => datasource.loadEnterprises(),
    ).thenAnswer((_) async => [enterpriseModel]);

    expect(await repository.loadEnterprises(), [enterpriseModel.toEntity()]);
    verify(() => datasource.loadEnterprises()).called(1);
  });

  test('loadSelectedEnterprise converts the selected model', () async {
    when(
      () => datasource.loadSelectedEnterprise(),
    ).thenAnswer((_) async => enterpriseModel);

    expect(
      await repository.loadSelectedEnterprise(),
      enterpriseModel.toEntity(),
    );
    verify(() => datasource.loadSelectedEnterprise()).called(1);
  });

  test('addEnterprise rejects a normalized duplicate before login', () async {
    final duplicateParams = EntityFactory.makeAddEnterpriseParams(
      enterpriseName: ' ${enterpriseModel.enterpriseName} ',
    );
    when(
      () => datasource.loadEnterprises(),
    ).thenAnswer((_) async => [enterpriseModel]);

    expect(
      () => repository.addEnterprise(duplicateParams),
      throwsA(isA<AppException>()),
    );
    verifyNever(
      () => loginRepository.login(
        LoginParams(
          enterpriseName: duplicateParams.enterpriseName,
          user: duplicateParams.user,
          password: duplicateParams.password,
        ),
      ),
    );
  });

  test(
    'addEnterprise authenticates, saves, and selects the first item',
    () async {
      final entity = enterpriseModel.toEntity().copyWith(
        annulBsUser: true,
        annulFirebaseSubEnterprises: true,
      );
      final expectedModel = FirebaseEnterpriseModel.fromEntity(entity);
      when(() => datasource.loadEnterprises()).thenAnswer((_) async => []);
      when(
        () => loginRepository.login(
          LoginParams(
            enterpriseName: addParams.enterpriseName,
            user: addParams.user,
            password: addParams.password,
          ),
        ),
      ).thenAnswer((_) async => entity);
      when(
        () => datasource.saveEnterprises([expectedModel]),
      ).thenAnswer((_) async {});
      when(
        () => datasource.loadSelectedEnterprise(),
      ).thenAnswer((_) async => null);
      when(
        () => datasource.saveSelectedEnterprise(expectedModel),
      ).thenAnswer((_) async {});

      expect(await repository.addEnterprise(addParams), entity);
      verify(() => datasource.saveEnterprises([expectedModel])).called(1);
      verify(() => datasource.saveSelectedEnterprise(expectedModel)).called(1);
    },
  );

  test('removeEnterprise rejects the active enterprise', () async {
    when(
      () => datasource.loadSelectedEnterprise(),
    ).thenAnswer((_) async => enterpriseModel);

    expect(
      () => repository.removeEnterprise(enterpriseModel.toEntity()),
      throwsA(isA<AppException>()),
    );
    verifyNever(() => datasource.loadEnterprises());
  });

  test('removeEnterprise saves only the remaining models', () async {
    final removedModel = FirebaseEnterpriseModel.fromEntity(
      EntityFactory.makeFirebaseEnterpriseEntity(),
    );
    when(
      () => datasource.loadSelectedEnterprise(),
    ).thenAnswer((_) async => enterpriseModel);
    when(
      () => datasource.loadEnterprises(),
    ).thenAnswer((_) async => [enterpriseModel, removedModel]);
    when(
      () => datasource.saveEnterprises([enterpriseModel]),
    ).thenAnswer((_) async {});

    await repository.removeEnterprise(removedModel.toEntity());

    verify(() => datasource.saveEnterprises([enterpriseModel])).called(1);
  });
}

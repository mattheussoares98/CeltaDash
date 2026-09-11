import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/data/data.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/login/data/data.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockHomeDatasource remoteDatasource;
  late MockHomeLocalDatasource localDatasource;
  late MockHomeGoalDatasource goalDatasource;
  late MockFirebaseLoginEnterpriseDatasource firebaseEnterpriseDatasource;
  late HomeRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockHomeDatasource();
    localDatasource = MockHomeLocalDatasource();
    goalDatasource = MockHomeGoalDatasource();
    firebaseEnterpriseDatasource = MockFirebaseLoginEnterpriseDatasource();
    repository = HomeRepositoryImpl(
      remoteDatasource,
      localDatasource,
      goalDatasource,
      firebaseEnterpriseDatasource,
    );
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

  test('getMonthlyGoals converts datasource models into entities', () async {
    final firebaseEnterpriseId = faker.guid.guid();
    final entity = MonthlyGoalEntity(
      enterpriseId: faker.randomGenerator.integer(100),
      month: faker.date.dateTime(),
      value: faker.randomGenerator.decimal(),
      userName: faker.person.name(),
    );
    final model = MonthlyGoalModel.fromEntity(entity);
    when(
      () => goalDatasource.getMonthlyGoals(
        firebaseEnterpriseId: firebaseEnterpriseId,
        year: entity.month.year,
      ),
    ).thenAnswer((_) async => [model]);

    final result = await repository.getMonthlyGoals(
      firebaseEnterpriseId: firebaseEnterpriseId,
      year: entity.month.year,
    );

    expect(result, [entity]);
    verify(
      () => goalDatasource.getMonthlyGoals(
        firebaseEnterpriseId: firebaseEnterpriseId,
        year: entity.month.year,
      ),
    ).called(1);
  });

  test('saveMonthlyGoal converts the entity and delegates saving', () async {
    final firebaseEnterpriseId = faker.guid.guid();
    final entity = MonthlyGoalEntity(
      enterpriseId: faker.randomGenerator.integer(100),
      month: faker.date.dateTime(),
      value: faker.randomGenerator.decimal(),
      userName: faker.person.name(),
    );
    final model = MonthlyGoalModel.fromEntity(entity);
    when(
      () => goalDatasource.saveMonthlyGoal(
        firebaseEnterpriseId: firebaseEnterpriseId,
        goal: model,
      ),
    ).thenAnswer((_) async {});

    await repository.saveMonthlyGoal(
      firebaseEnterpriseId: firebaseEnterpriseId,
      goal: entity,
    );

    verify(
      () => goalDatasource.saveMonthlyGoal(
        firebaseEnterpriseId: firebaseEnterpriseId,
        goal: model,
      ),
    ).called(1);
  });

  test('logout delegates to the local datasource', () async {
    when(() => localDatasource.logout()).thenAnswer((_) async {});

    await repository.logout();

    verify(() => localDatasource.logout()).called(1);
  });

  group('syncSubEnterprises', () {
    test('does not update Firebase when lists are identical', () async {
      const sub = FirebaseSubEnterpriseEntity(
        id: 1,
        name: 'Store 1',
        personalizedCode: '01',
        cnpj: '12345678000100',
        enabled: true,
      );
      const activeEnterprise = FirebaseEnterpriseEntity(
        baseUrl: 'https://api.com',
        enterpriseName: 'test',
        bsUser: null,
        firebaseSubEnterprises: [sub],
        firebaseId: 'test_id',
      );
      final erpEnterprises = [
        const HomeEnterpriseEntity(
          id: 1,
          name: 'Store 1',
          personalizedCode: '01',
          cnpj: '12345678000100',
          enabled: false,
        ),
      ];

      await repository.syncSubEnterprises(
        activeEnterprise: activeEnterprise,
        erpEnterprises: erpEnterprises,
      );

      verifyNever(
        () => firebaseEnterpriseDatasource.updateSubEnterprises(
          firebaseId: any(named: 'firebaseId'),
          subEnterprises: any(named: 'subEnterprises'),
        ),
      );
    });

    test(
      'updates Firebase when ERP has new stores or duplicates exist',
      () async {
        const sub1 = FirebaseSubEnterpriseEntity(
          id: 1,
          name: 'Store 1',
          personalizedCode: '01',
          cnpj: '12345678000100',
          enabled: true,
        );
        const activeEnterprise = FirebaseEnterpriseEntity(
          baseUrl: 'https://api.com',
          enterpriseName: 'test',
          bsUser: null,
          firebaseSubEnterprises: [sub1],
          firebaseId: 'test_id',
        );
        final erpEnterprises = [
          const HomeEnterpriseEntity(
            id: 1,
            name: 'Store 1',
            personalizedCode: '01',
            cnpj: '12345678000100',
            enabled: false,
          ),
          const HomeEnterpriseEntity(
            id: 2,
            name: 'Store 2',
            personalizedCode: '02',
            cnpj: '99999999000199',
            enabled: false,
          ),
        ];

        when(
          () => firebaseEnterpriseDatasource.updateSubEnterprises(
            firebaseId: any(named: 'firebaseId'),
            subEnterprises: any(named: 'subEnterprises'),
          ),
        ).thenAnswer((_) async {});

        await repository.syncSubEnterprises(
          activeEnterprise: activeEnterprise,
          erpEnterprises: erpEnterprises,
        );

        verify(
          () => firebaseEnterpriseDatasource.updateSubEnterprises(
            firebaseId: 'test_id',
            subEnterprises: any(named: 'subEnterprises'),
          ),
        ).called(1);
      },
    );

    test(
      'preserves multiple sub-enterprises having the same CNPJ but different IDs',
      () async {
        const activeEnterprise = FirebaseEnterpriseEntity(
          baseUrl: 'https://api.com',
          enterpriseName: 'test',
          bsUser: null,
          firebaseSubEnterprises: [],
          firebaseId: 'test_id',
        );
        final erpEnterprises = [
          const HomeEnterpriseEntity(
            id: 1,
            name: 'Store 1',
            personalizedCode: '01',
            cnpj: '12345678000100',
            enabled: false,
          ),
          const HomeEnterpriseEntity(
            id: 2,
            name: 'Store 2',
            personalizedCode: '02',
            cnpj: '12345678000100', // Same CNPJ as Store 1
            enabled: false,
          ),
        ];

        late List<FirebaseSubEnterpriseModel> savedModels;
        when(
          () => firebaseEnterpriseDatasource.updateSubEnterprises(
            firebaseId: any(named: 'firebaseId'),
            subEnterprises: any(named: 'subEnterprises'),
          ),
        ).thenAnswer((invocation) async {
          savedModels =
              invocation.namedArguments[#subEnterprises]
                  as List<FirebaseSubEnterpriseModel>;
        });

        await repository.syncSubEnterprises(
          activeEnterprise: activeEnterprise,
          erpEnterprises: erpEnterprises,
        );

        expect(savedModels.length, 2);
        expect(savedModels[0].id, 1);
        expect(savedModels[1].id, 2);
        expect(savedModels[0].cnpj, savedModels[1].cnpj);
      },
    );

    test('does not update Firebase when erpEnterprises is empty', () async {
      const sub = FirebaseSubEnterpriseEntity(
        id: 1,
        name: 'Store 1',
        personalizedCode: '01',
        cnpj: '12345678000100',
        enabled: true,
      );
      const activeEnterprise = FirebaseEnterpriseEntity(
        baseUrl: 'https://api.com',
        enterpriseName: 'test',
        bsUser: null,
        firebaseSubEnterprises: [sub],
        firebaseId: 'test_id',
      );

      await repository.syncSubEnterprises(
        activeEnterprise: activeEnterprise,
        erpEnterprises: const [],
      );

      verifyNever(
        () => firebaseEnterpriseDatasource.updateSubEnterprises(
          firebaseId: any(named: 'firebaseId'),
          subEnterprises: any(named: 'subEnterprises'),
        ),
      );
    });

    test('preserves existing subEnterprises not present in erpEnterprises', () async {
      const sub1 = FirebaseSubEnterpriseEntity(
        id: 1,
        name: 'Store 1',
        personalizedCode: '01',
        cnpj: '12345678000100',
        enabled: true,
      );
      const sub2 = FirebaseSubEnterpriseEntity(
        id: 2,
        name: 'Store 2',
        personalizedCode: '02',
        cnpj: '99999999000199',
        enabled: false,
      );
      const activeEnterprise = FirebaseEnterpriseEntity(
        baseUrl: 'https://api.com',
        enterpriseName: 'test',
        bsUser: null,
        firebaseSubEnterprises: [sub1, sub2],
        firebaseId: 'test_id',
      );
      final erpEnterprises = [
        const HomeEnterpriseEntity(
          id: 1,
          name: 'Store 1 Updated',
          personalizedCode: '01',
          cnpj: '12345678000100',
          enabled: false,
        ),
      ];

      late List<FirebaseSubEnterpriseModel> savedModels;
      when(
        () => firebaseEnterpriseDatasource.updateSubEnterprises(
          firebaseId: any(named: 'firebaseId'),
          subEnterprises: any(named: 'subEnterprises'),
        ),
      ).thenAnswer((invocation) async {
        savedModels =
            invocation.namedArguments[#subEnterprises]
                as List<FirebaseSubEnterpriseModel>;
      });

      await repository.syncSubEnterprises(
        activeEnterprise: activeEnterprise,
        erpEnterprises: erpEnterprises,
      );

      expect(savedModels.length, 2);
      expect(savedModels[0].id, 1);
      expect(savedModels[0].name, 'Store 1 Updated');
      expect(savedModels[0].enabled, isTrue);
      expect(savedModels[1].id, 2);
      expect(savedModels[1].name, 'Store 2');
    });
  });
}

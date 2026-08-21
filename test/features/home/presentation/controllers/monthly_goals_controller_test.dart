import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockHomeRepository repository;
  late FirebaseEnterpriseEntity activeEnterprise;
  late List<MonthlyGoalEntity> goals;

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      activeEcParamsStateControllerProvider.overrideWith(
        () => FakeActiveEcParams(EntityFactory.makeEcParams()),
      ),
      homeRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockHomeRepository();
    activeEnterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    goals = [
      MonthlyGoalEntity(
        enterpriseId: faker.randomGenerator.integer(100),
        month: faker.date.dateTime(),
        value: faker.randomGenerator.decimal(),
        userName: faker.person.name(),
      ),
    ];
    when(
      () => repository.loadActiveEnterprise(),
    ).thenAnswer((_) async => activeEnterprise);
    when(
      () => repository.getMonthlyGoals(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
      ),
    ).thenAnswer((_) async => goals);
  });

  test('build loads and indexes every saved goal', () async {
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(monthlyGoalsControllerProvider.future);
    final cachedResult = await container.read(
      monthlyGoalsControllerProvider.future,
    );
    final goal = goals.single;
    final key = MonthlyGoalKey(
      enterpriseId: goal.enterpriseId,
      year: goal.month.year,
      month: goal.month.month,
    );

    expect(result, {key: goal});
    expect(cachedResult, result);
    verify(
      () => repository.getMonthlyGoals(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
      ),
    ).called(1);
  });

  test('build exposes repository failures', () async {
    final error = Exception(faker.lorem.sentence());
    when(
      () => repository.getMonthlyGoals(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
      ),
    ).thenThrow(error);
    final container = makeContainer();
    addTearDown(container.dispose);

    await expectLater(
      container.read(monthlyGoalsControllerProvider.future),
      throwsA(same(error)),
    );
  });

  test('updateGoal persists and updates the cached month', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(monthlyGoalsControllerProvider.future);
    final month = faker.date.dateTime();
    final enterpriseId = faker.randomGenerator.integer(100);
    final value = faker.randomGenerator.decimal();
    final expectedGoal = MonthlyGoalEntity(
      enterpriseId: enterpriseId,
      month: DateTime(month.year, month.month),
      value: value,
      userName: activeEnterprise.bsUser!.name!,
    );
    when(
      () => repository.saveMonthlyGoal(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
        goal: expectedGoal,
      ),
    ).thenAnswer((_) async {});

    await container
        .read(monthlyGoalsControllerProvider.notifier)
        .updateGoal(enterpriseId: enterpriseId, month: month, value: value);

    final key = MonthlyGoalKey(
      enterpriseId: enterpriseId,
      year: month.year,
      month: month.month,
    );
    expect(
      container.read(monthlyGoalsControllerProvider).requireValue[key],
      expectedGoal,
    );
  });

  test('updateGoal preserves the cache when saving fails', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    final previous = await container.read(
      monthlyGoalsControllerProvider.future,
    );
    final month = faker.date.dateTime();
    final enterpriseId = faker.randomGenerator.integer(100);
    final value = faker.randomGenerator.decimal();
    final expectedGoal = MonthlyGoalEntity(
      enterpriseId: enterpriseId,
      month: DateTime(month.year, month.month),
      value: value,
      userName: activeEnterprise.bsUser!.name!,
    );
    final error = Exception(faker.lorem.sentence());
    when(
      () => repository.saveMonthlyGoal(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
        goal: expectedGoal,
      ),
    ).thenThrow(error);

    await expectLater(
      container
          .read(monthlyGoalsControllerProvider.notifier)
          .updateGoal(enterpriseId: enterpriseId, month: month, value: value),
      throwsA(same(error)),
    );
    expect(
      container.read(monthlyGoalsControllerProvider).requireValue,
      previous,
    );
  });
}

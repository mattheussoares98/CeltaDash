import 'package:celta_dash/features/home/data/data.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late FakeHomeGoalFirebaseStorage firebaseStorage;
  late HomeGoalDatasource datasource;
  late MonthlyGoalEntity goal;
  late String firebaseEnterpriseId;
  late String goalId;
  late String path;

  setUp(() {
    firebaseStorage = FakeHomeGoalFirebaseStorage();
    datasource = HomeGoalDatasource(firebaseStorage);
    firebaseEnterpriseId = faker.guid.guid();
    final month = faker.date.dateTime();
    goal = MonthlyGoalEntity(
      enterpriseId: faker.randomGenerator.integer(100),
      month: DateTime(month.year, month.month),
      value: faker.randomGenerator.decimal(),
      userName: faker.person.name(),
    );
    goalId = '${goal.enterpriseId}-${DateFormat('yyyy-MM').format(goal.month)}';
    path = 'enterprises/$firebaseEnterpriseId/goals/all';
  });

  test('getMonthlyGoals maps every valid Firebase goal', () async {
    final otherGoal = goal.copyWith(
      enterpriseId: goal.enterpriseId + 1,
      month: DateTime(goal.month.year, goal.month.month - 1),
    );
    final otherGoalId =
        '${otherGoal.enterpriseId}-${DateFormat('yyyy-MM').format(otherGoal.month)}';
    firebaseStorage.getResult = FakeDoc({
      goalId: MonthlyGoalModel.fromEntity(goal).toJson(),
      otherGoalId: MonthlyGoalModel.fromEntity(otherGoal).toJson(),
      'invalid-key': MonthlyGoalModel.fromEntity(goal).toJson(),
      '${goal.enterpriseId}-${goal.month.year}-13': {
        'value': goal.value,
        'userName': goal.userName,
      },
      '${goal.enterpriseId + 2}-${DateFormat('yyyy-MM').format(goal.month)}': {
        'value': 'invalid',
      },
    }, null);

    final result = await datasource.getMonthlyGoals(
      firebaseEnterpriseId: firebaseEnterpriseId,
    );

    expect(result.map((model) => model.toEntity()), [goal, otherGoal]);
    expect(firebaseStorage.getPath, path);
  });

  test(
    'getMonthlyGoals returns an empty list when there are no saved goals',
    () async {
      firebaseStorage.getResult = const FakeDoc({}, null);

      final result = await datasource.getMonthlyGoals(
        firebaseEnterpriseId: firebaseEnterpriseId,
      );

      expect(result, isEmpty);
    },
  );

  test(
    'saveMonthlyGoal merges the goal without replacing its history',
    () async {
      final model = MonthlyGoalModel.fromEntity(goal);

      await datasource.saveMonthlyGoal(
        firebaseEnterpriseId: firebaseEnterpriseId,
        goal: model,
      );

      expect(firebaseStorage.putPath, path);
      expect(firebaseStorage.putData, {goalId: model.toJson()});
      expect(firebaseStorage.putMerge, isTrue);
    },
  );

  test('getMonthlyGoals propagates Firebase failures', () async {
    final error = Exception(faker.lorem.sentence());
    firebaseStorage.getError = error;

    expect(
      () => datasource.getMonthlyGoals(
        firebaseEnterpriseId: firebaseEnterpriseId,
      ),
      throwsA(same(error)),
    );
  });

  test('saveMonthlyGoal propagates Firebase failures', () async {
    final error = Exception(faker.lorem.sentence());
    firebaseStorage.putError = error;

    expect(
      () => datasource.saveMonthlyGoal(
        firebaseEnterpriseId: firebaseEnterpriseId,
        goal: MonthlyGoalModel.fromEntity(goal),
      ),
      throwsA(same(error)),
    );
  });
}

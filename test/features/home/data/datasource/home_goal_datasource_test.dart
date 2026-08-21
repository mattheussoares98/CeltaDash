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
    goal = MonthlyGoalEntity(
      enterpriseId: faker.randomGenerator.integer(100),
      month: faker.date.dateTime(),
      value: faker.randomGenerator.decimal(),
      userName: faker.person.name(),
    );
    goalId = '${goal.enterpriseId}-${DateFormat('yyyy-MM').format(goal.month)}';
    path = 'enterprises/$firebaseEnterpriseId/goals/all';
  });

  test('getMonthlyGoal maps the matching Firebase goal', () async {
    firebaseStorage.getResult = FakeDoc({
      goalId: MonthlyGoalModel.fromEntity(goal).toJson(),
    }, null);

    final result = await datasource.getMonthlyGoal(
      firebaseEnterpriseId: firebaseEnterpriseId,
      enterpriseId: goal.enterpriseId,
      month: goal.month,
    );

    expect(result?.toEntity(), goal);
    expect(firebaseStorage.getPath, path);
  });

  test(
    'getMonthlyGoal returns null when the month has no saved goal',
    () async {
      firebaseStorage.getResult = const FakeDoc({}, null);

      final result = await datasource.getMonthlyGoal(
        firebaseEnterpriseId: firebaseEnterpriseId,
        enterpriseId: goal.enterpriseId,
        month: goal.month,
      );

      expect(result, isNull);
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

  test('getMonthlyGoal propagates Firebase failures', () async {
    final error = Exception(faker.lorem.sentence());
    firebaseStorage.getError = error;

    expect(
      () => datasource.getMonthlyGoal(
        firebaseEnterpriseId: firebaseEnterpriseId,
        enterpriseId: goal.enterpriseId,
        month: goal.month,
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

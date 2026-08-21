import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_goals_controller.g.dart';

@Riverpod(keepAlive: true)
class MonthlyGoalsController extends _$MonthlyGoalsController {
  @override
  Future<Map<MonthlyGoalKey, MonthlyGoalEntity>> build() async {
    ref.watch(activeEcParamsStateControllerProvider);
    final repository = ref.watch(homeRepositoryProvider);
    final activeEnterprise = await repository.loadActiveEnterprise();
    final firebaseEnterpriseId = activeEnterprise?.firebaseId;
    if (firebaseEnterpriseId == null) return const {};

    final goals = await repository.getMonthlyGoals(
      firebaseEnterpriseId: firebaseEnterpriseId,
    );
    return Map.unmodifiable({
      for (final goal in goals) _keyFor(goal.enterpriseId, goal.month): goal,
    });
  }

  Future<void> updateGoal({
    required int enterpriseId,
    required DateTime month,
    required double value,
  }) async {
    final previous = state.requireValue;
    final repository = ref.read(homeRepositoryProvider);
    final activeEnterprise = await repository.loadActiveEnterprise();
    final firebaseEnterpriseId = activeEnterprise?.firebaseId;
    if (firebaseEnterpriseId == null) {
      throw StateError('The active enterprise has no Firebase identifier.');
    }

    final goal = MonthlyGoalEntity(
      enterpriseId: enterpriseId,
      month: DateTime(month.year, month.month),
      value: value,
      userName: activeEnterprise?.bsUser?.name ?? '',
    );
    await repository.saveMonthlyGoal(
      firebaseEnterpriseId: firebaseEnterpriseId,
      goal: goal,
    );
    state = AsyncData(
      Map.unmodifiable({...previous, _keyFor(enterpriseId, month): goal}),
    );
  }

  MonthlyGoalKey _keyFor(int enterpriseId, DateTime month) => MonthlyGoalKey(
    enterpriseId: enterpriseId,
    year: month.year,
    month: month.month,
  );
}

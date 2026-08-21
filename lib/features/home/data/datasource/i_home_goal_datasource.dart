import 'package:celta_dash/features/home/data/models/models.dart';

abstract class IHomeGoalDatasource {
  Future<List<MonthlyGoalModel>> getMonthlyGoals({
    required String firebaseEnterpriseId,
  });

  Future<void> saveMonthlyGoal({
    required String firebaseEnterpriseId,
    required MonthlyGoalModel goal,
  });
}

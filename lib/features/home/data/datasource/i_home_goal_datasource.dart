import 'package:celta_dash/features/home/data/models/models.dart';

abstract class IHomeGoalDatasource {
  Future<MonthlyGoalModel?> getMonthlyGoal({
    required String firebaseEnterpriseId,
    required int enterpriseId,
    required DateTime month,
  });

  Future<void> saveMonthlyGoal({
    required String firebaseEnterpriseId,
    required MonthlyGoalModel goal,
  });
}

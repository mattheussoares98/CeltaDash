import 'package:celta_dash/data/database/database.dart';
import 'package:celta_dash/features/home/data/datasource/datasource.dart';
import 'package:celta_dash/features/home/data/models/models.dart';
import 'package:intl/intl.dart';

class HomeGoalDatasource implements IHomeGoalDatasource {
  const HomeGoalDatasource(this._firebaseStorage);

  final FirebaseStorage _firebaseStorage;

  @override
  Future<MonthlyGoalModel?> getMonthlyGoal({
    required String firebaseEnterpriseId,
    required int enterpriseId,
    required DateTime month,
  }) async {
    final snapshot = await _firebaseStorage.get(
      path: _goalPath(firebaseEnterpriseId),
    );
    final data = snapshot?.data();
    if (data is! Map) return null;

    final goalJson = data[_goalId(enterpriseId, month)];
    if (goalJson is! Map) return null;

    return MonthlyGoalModel.fromJson(
      goalJson,
      enterpriseId: enterpriseId,
      month: month,
    );
  }

  @override
  Future<void> saveMonthlyGoal({
    required String firebaseEnterpriseId,
    required MonthlyGoalModel goal,
  }) => _firebaseStorage.put(
    path: _goalPath(firebaseEnterpriseId),
    data: {_goalId(goal.enterpriseId, goal.month): goal.toJson()},
    merge: true,
  );

  String _goalPath(String firebaseEnterpriseId) =>
      'enterprises/$firebaseEnterpriseId/goals/all';

  String _goalId(int enterpriseId, DateTime month) =>
      '$enterpriseId-${DateFormat('yyyy-MM').format(month)}';
}

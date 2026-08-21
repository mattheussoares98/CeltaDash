import 'package:celta_dash/data/database/database.dart';
import 'package:celta_dash/features/home/data/datasource/datasource.dart';
import 'package:celta_dash/features/home/data/models/models.dart';
import 'package:intl/intl.dart';

class HomeGoalDatasource implements IHomeGoalDatasource {
  const HomeGoalDatasource(this._firebaseStorage);

  final FirebaseStorage _firebaseStorage;

  @override
  Future<List<MonthlyGoalModel>> getMonthlyGoals({
    required String firebaseEnterpriseId,
  }) async {
    final snapshot = await _firebaseStorage.get(
      path: _goalPath(firebaseEnterpriseId),
    );
    final data = snapshot?.data();
    if (data is! Map) return [];

    final goals = <MonthlyGoalModel>[];
    for (final entry in data.entries) {
      final match = RegExp(
        r'^(\d+)-(\d{4})-(\d{2})$',
      ).firstMatch(entry.key.toString());
      if (match == null || entry.value is! Map) continue;

      final enterpriseId = int.parse(match.group(1)!);
      final year = int.parse(match.group(2)!);
      final month = int.parse(match.group(3)!);
      if (month < 1 || month > 12) continue;

      try {
        goals.add(
          MonthlyGoalModel.fromJson(
            entry.value as Map,
            enterpriseId: enterpriseId,
            month: DateTime(year, month),
          ),
        );
      } catch (_) {
        continue;
      }
    }
    return goals;
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

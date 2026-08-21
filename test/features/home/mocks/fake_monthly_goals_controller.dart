import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';

class FakeMonthlyGoalsController extends MonthlyGoalsController {
  FakeMonthlyGoalsController(this.goals);

  final Map<MonthlyGoalKey, MonthlyGoalEntity> goals;

  @override
  Future<Map<MonthlyGoalKey, MonthlyGoalEntity>> build() async => goals;
}

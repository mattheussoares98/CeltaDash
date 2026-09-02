import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/domain/entities/entities.dart';

abstract class IHomeRepository {
  Future<List<HomeEnterpriseEntity>> getEnterprises(EcParams ecParams);

  Future<AppMode> loadAppMode();

  Future<void> saveAppMode(AppMode mode);

  Future<FirebaseEnterpriseEntity?> loadActiveEnterprise();

  Future<List<MonthlyGoalEntity>> getMonthlyGoals({
    required String firebaseEnterpriseId,
    required int year,
  });

  Future<void> saveMonthlyGoal({
    required String firebaseEnterpriseId,
    required MonthlyGoalEntity goal,
  });

  Future<void> syncSubEnterprises({
    required FirebaseEnterpriseEntity activeEnterprise,
    required List<HomeEnterpriseEntity> erpEnterprises,
  });

  Future<void> logout();
}

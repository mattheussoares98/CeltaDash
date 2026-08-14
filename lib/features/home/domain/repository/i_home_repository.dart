import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/domain/entities/entities.dart';

abstract class IHomeRepository {
  Future<List<HomeEnterpriseEntity>> getEnterprises(EcParams ecParams);

  Future<AppMode> loadAppMode();

  Future<void> saveAppMode(AppMode mode);

  Future<FirebaseEnterpriseEntity?> loadActiveEnterprise();

  Future<void> logout();
}

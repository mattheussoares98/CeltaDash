import 'package:celta_dash/core/domain/domain.dart';

abstract class IHomeLocalDatasource {
  Future<AppMode> loadAppMode();

  Future<void> saveAppMode(AppMode mode);

  Future<FirebaseEnterpriseEntity?> loadActiveEnterprise();

  Future<void> logout();
}

import 'package:celta_dash/core/domain/domain.dart';

abstract class ISplashRepository {
  Future<bool> isUpdateRequired();
  Future<FirebaseEnterpriseEntity?> getSavedEnterprise();
}

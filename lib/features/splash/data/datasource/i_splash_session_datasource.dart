import 'package:celta_dash/core/domain/domain.dart';

abstract class ISplashSessionDatasource {
  Future<FirebaseEnterpriseEntity?> getSavedEnterprise();
}

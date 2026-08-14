// lib/features/login/data/datasource/i_login_datasource.dart
import 'package:celta_dash/features/login/data/models/models.dart';

abstract class ILoginDatasource {
  Future<FirebaseEnterpriseModel> getEnterpriseConfig({
    required String enterpriseName,
  });

  Future<BsUserModel> authenticateBs({
    required String user,
    required String password,
    required String url,
  });
}

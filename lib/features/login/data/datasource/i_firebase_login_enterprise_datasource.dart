// lib/features/login/data/datasource/i_firebase_login_enterprise_datasource.dart
import 'package:celta_dash/core/data/data.dart';

abstract class IFirebaseLoginEnterpriseDatasource {
  Future<FirebaseEnterpriseModel> getEnterpriseConfig({
    required String enterpriseName,
  });
}

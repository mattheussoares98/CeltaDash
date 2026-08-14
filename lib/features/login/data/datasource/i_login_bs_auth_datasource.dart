// lib/features/login/data/datasource/i_login_bs_auth_datasource.dart
import 'package:celta_dash/features/login/data/models/models.dart';

abstract class ILoginBsAuthDatasource {
  Future<BsUserModel> authenticateBs({
    required String user,
    required String password,
    required String url,
  });
}

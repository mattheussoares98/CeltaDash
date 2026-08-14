import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/splash/data/datasource/i_splash_session_datasource.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:hive/hive.dart';

class LocalSplashSessionDatasource implements ISplashSessionDatasource {
  final Box box;

  const LocalSplashSessionDatasource(this.box);

  @override
  Future<FirebaseEnterpriseEntity?> getSavedEnterprise() async {
    try {
      final savedEnterprise = await box.get(DatabaseKeys.enterprise.name);
      if (savedEnterprise != null && savedEnterprise != '') {
        return FirebaseEnterpriseModel.fromJson(savedEnterprise).toEntity();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

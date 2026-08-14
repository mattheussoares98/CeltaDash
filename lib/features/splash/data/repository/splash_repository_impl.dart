import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/splash/data/datasource/datasource.dart';
import 'package:celta_dash/features/splash/domain/repository/repository.dart';
import 'package:celta_dash/utils/utils.dart';

class SplashRepositoryImpl implements ISplashRepository {
  final IDeviceService deviceService;
  final IVersionDatasource versionDatasource;
  final ISplashSessionDatasource sessionDatasource;

  const SplashRepositoryImpl({
    required this.deviceService,
    required this.versionDatasource,
    required this.sessionDatasource,
  });

  @override
  Future<bool> isUpdateRequired() async {
    try {
      final localVersion = await deviceService.getAppVersion();
      final remoteVersion = await versionDatasource.getRequiredVersion();

      if (remoteVersion == null) return false;

      final localParsed =
          localVersion.replaceAll(RegExp(r'\.'), '').toInt() ?? 0;
      final remoteParsed =
          remoteVersion.replaceAll(RegExp(r'\.'), '').toInt() ?? 0;

      return localParsed < remoteParsed;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<FirebaseEnterpriseEntity?> getSavedEnterprise() async {
    return await sessionDatasource.getSavedEnterprise();
  }
}

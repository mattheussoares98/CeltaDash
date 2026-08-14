import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/home/data/datasource/datasource.dart';

class HomeLocalDatasource implements IHomeLocalDatasource {
  const HomeLocalDatasource(this._storage);

  static const _appModeKey = 'appMode';
  static const _enterpriseKey = 'enterprise';

  final IAppStorage _storage;

  @override
  Future<AppMode> loadAppMode() async {
    final savedMode = await _storage.get(_appModeKey);
    return AppMode.values.firstWhere(
      (mode) => mode.name == savedMode,
      orElse: () => AppMode.sales,
    );
  }

  @override
  Future<void> saveAppMode(AppMode mode) =>
      _storage.put(_appModeKey, mode.name);

  @override
  Future<FirebaseEnterpriseEntity?> loadActiveEnterprise() async {
    final savedEnterprise = await _storage.get(_enterpriseKey);
    if (savedEnterprise == null || savedEnterprise == '') return null;
    return FirebaseEnterpriseModel.fromJson(savedEnterprise as Map).toEntity();
  }
}

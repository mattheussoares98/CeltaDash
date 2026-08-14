import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/data/datasource/datasource.dart';
import 'package:celta_dash/features/home/domain/domain.dart';

class HomeRepositoryImpl implements IHomeRepository {
  const HomeRepositoryImpl(this._remoteDatasource, this._localDatasource);

  final IHomeDatasource _remoteDatasource;
  final IHomeLocalDatasource _localDatasource;

  @override
  Future<List<HomeEnterpriseEntity>> getEnterprises(EcParams ecParams) async {
    final models = await _remoteDatasource.getEnterprises(ecParams);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AppMode> loadAppMode() => _localDatasource.loadAppMode();

  @override
  Future<void> saveAppMode(AppMode mode) => _localDatasource.saveAppMode(mode);

  @override
  Future<FirebaseEnterpriseEntity?> loadActiveEnterprise() =>
      _localDatasource.loadActiveEnterprise();

  @override
  Future<void> logout() => _localDatasource.logout();
}

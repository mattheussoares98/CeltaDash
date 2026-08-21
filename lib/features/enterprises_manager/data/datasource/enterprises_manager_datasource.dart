import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/enterprises_manager/data/datasource/datasource.dart';

class EnterprisesManagerDatasource implements IEnterprisesManagerDatasource {
  const EnterprisesManagerDatasource(this._storage);

  static const _enterprisesKey = 'allEnterprises';
  static const _selectedEnterpriseKey = 'enterprise';

  final IAppStorage _storage;

  @override
  Future<List<FirebaseEnterpriseModel>> loadEnterprises() async {
    final savedEnterprises = await _storage.get(_enterprisesKey);
    if (savedEnterprises is! List) return const [];

    return savedEnterprises
        .map((item) => FirebaseEnterpriseModel.fromJson(item as Map))
        .toList(growable: false);
  }

  @override
  Future<FirebaseEnterpriseModel?> loadSelectedEnterprise() async {
    final savedEnterprise = await _storage.get(_selectedEnterpriseKey);
    if (savedEnterprise == null || savedEnterprise == '') return null;

    return FirebaseEnterpriseModel.fromJson(savedEnterprise as Map);
  }

  @override
  Future<void> saveEnterprises(List<FirebaseEnterpriseModel> enterprises) =>
      _storage.put(
        _enterprisesKey,
        enterprises.map((enterprise) => enterprise.toJson()).toList(),
      );

  @override
  Future<void> saveSelectedEnterprise(FirebaseEnterpriseModel enterprise) =>
      _storage.put(_selectedEnterpriseKey, enterprise.toJson());
}

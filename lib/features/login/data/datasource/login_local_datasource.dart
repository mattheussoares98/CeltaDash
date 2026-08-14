import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/login/data/datasource/datasource.dart';
import 'package:celta_dash/features/login/domain/entities/entities.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';

class LoginLocalDatasource implements ILoginLocalDatasource {
  const LoginLocalDatasource(this._storage);

  final IAppStorage _storage;

  @override
  Future<FirebaseEnterpriseEntity?> loadLastEnterprise() async {
    final savedEnterprise = await _storage.get(DatabaseKeys.enterprise.name);
    if (savedEnterprise == null || savedEnterprise == '') return null;
    return FirebaseEnterpriseModel.fromJson(savedEnterprise as Map).toEntity();
  }
}

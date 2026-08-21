import 'package:celta_dash/core/data/data.dart';

abstract class IEnterprisesManagerDatasource {
  Future<List<FirebaseEnterpriseModel>> loadEnterprises();

  Future<FirebaseEnterpriseModel?> loadSelectedEnterprise();

  Future<void> saveEnterprises(List<FirebaseEnterpriseModel> enterprises);

  Future<void> saveSelectedEnterprise(FirebaseEnterpriseModel enterprise);
}

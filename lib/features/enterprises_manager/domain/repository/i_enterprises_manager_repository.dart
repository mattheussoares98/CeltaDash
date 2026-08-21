import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/enterprises_manager/domain/entities/entities.dart';

abstract class IEnterprisesManagerRepository {
  Future<List<FirebaseEnterpriseEntity>> loadEnterprises();

  Future<FirebaseEnterpriseEntity?> loadSelectedEnterprise();

  Future<FirebaseEnterpriseEntity> addEnterprise(AddEnterpriseParams params);

  Future<void> removeEnterprise(FirebaseEnterpriseEntity enterprise);
}

import 'package:celta_dash/features/login/domain/entities/entities.dart';

abstract class ILoginLocalDatasource {
  Future<FirebaseEnterpriseEntity?> loadLastEnterprise();
}

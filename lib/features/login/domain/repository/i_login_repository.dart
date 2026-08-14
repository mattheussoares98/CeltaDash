// lib/features/login/domain/repository/i_login_repository.dart
import 'package:celta_dash/features/login/domain/entities/entities.dart';

abstract class ILoginRepository {
  Future<FirebaseEnterpriseEntity> login(LoginParams params);
}

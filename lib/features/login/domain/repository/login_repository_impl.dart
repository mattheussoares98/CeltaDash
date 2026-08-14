// lib/features/login/domain/repository/login_repository_impl.dart
import 'package:celta_dash/features/login/data/datasource/datasource.dart';
import 'package:celta_dash/features/login/domain/entities/entities.dart';
import 'package:celta_dash/features/login/domain/repository/i_login_repository.dart';

class LoginRepositoryImpl implements ILoginRepository {
  final IFirebaseLoginEnterpriseDatasource enterpriseDatasource;
  final ILoginBsAuthDatasource bsAuthDatasource;

  const LoginRepositoryImpl({
    required this.enterpriseDatasource,
    required this.bsAuthDatasource,
  });

  @override
  Future<FirebaseEnterpriseEntity> login(LoginParams params) async {
    final enterpriseModel = await enterpriseDatasource.getEnterpriseConfig(
      enterpriseName: params.enterpriseName,
    );

    final bsUserModel = await bsAuthDatasource.authenticateBs(
      user: params.user,
      password: params.password,
      url: enterpriseModel.baseUrl ?? '',
    );

    final enterpriseEntity = enterpriseModel.toEntity();
    return FirebaseEnterpriseEntity(
      baseUrl: enterpriseEntity.baseUrl,
      enterpriseName: params.enterpriseName.trim(),
      bsUser: bsUserModel.toEntity(),
      firebaseSubEnterprises: enterpriseEntity.firebaseSubEnterprises,
      firebaseId: enterpriseEntity.firebaseId,
    );
  }
}

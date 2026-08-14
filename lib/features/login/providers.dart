// lib/features/login/providers.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/login/data/data.dart';
import 'package:celta_dash/features/login/domain/repository/repository.dart';
import 'package:celta_dash/infra/databases/databases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IFirebaseLoginEnterpriseDatasource firebaseLoginEnterpriseDatasource(Ref ref) {
  return FirebaseLoginEnterpriseDatasource(FirebaseAdapter());
}

@riverpod
ILoginBsAuthDatasource loginBsAuthDatasource(Ref ref) {
  return LoginBsAuthDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ILoginLocalDatasource loginLocalDatasource(Ref ref) {
  return LoginLocalDatasource(ref.watch(appStorageProvider));
}

@riverpod
ILoginRepository loginRepository(Ref ref) {
  return LoginRepositoryImpl(
    enterpriseDatasource: ref.watch(firebaseLoginEnterpriseDatasourceProvider),
    bsAuthDatasource: ref.watch(loginBsAuthDatasourceProvider),
    localDatasource: ref.watch(loginLocalDatasourceProvider),
  );
}

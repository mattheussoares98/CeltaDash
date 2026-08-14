import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/core/providers/hive/hive.dart';
import 'package:celta_dash/features/splash/data/data.dart';
import 'package:celta_dash/features/splash/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IVersionDatasource versionDatasource(Ref ref) {
  return FirebaseVersionDatasource(ref.watch(firebaseStorageProvider));
}

@riverpod
ISplashSessionDatasource splashSessionDatasource(Ref ref) {
  return LocalSplashSessionDatasource(ref.watch(hiveBoxDashProvider));
}

@riverpod
ISplashRepository splashRepository(Ref ref) {
  return SplashRepositoryImpl(
    deviceService: ref.watch(deviceServiceProvider),
    versionDatasource: ref.watch(versionDatasourceProvider),
    sessionDatasource: ref.watch(splashSessionDatasourceProvider),
  );
}

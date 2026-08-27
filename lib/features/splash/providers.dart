import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/splash/data/data.dart';
import 'package:celta_dash/features/splash/domain/domain.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IVersionDatasource versionDatasource(Ref ref) {
  return FirebaseVersionDatasource(ref.watch(firebaseStorageProvider));
}

@Riverpod(keepAlive: true)
Box hiveBoxDash(Ref ref) {
  return Hive.box(DatabaseKeys.dash.name);
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

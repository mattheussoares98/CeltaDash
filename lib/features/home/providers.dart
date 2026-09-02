import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/data/data.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/login/login.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
DateTime resumeCurrentDate(Ref ref) => DateTime.now();

@riverpod
IHomeDatasource homeDatasource(Ref ref) {
  return HomeDatasource(ref.watch(httpClientProvider));
}

@riverpod
IHomeLocalDatasource homeLocalDatasource(Ref ref) {
  return HomeLocalDatasource(ref.watch(appStorageProvider));
}

@riverpod
IHomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(
    ref.watch(homeDatasourceProvider),
    ref.watch(homeLocalDatasourceProvider),
    HomeGoalDatasource(ref.watch(firebaseStorageProvider)),
    ref.watch(firebaseLoginEnterpriseDatasourceProvider),
  );
}

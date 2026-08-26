import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/app_analytics/data/data.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/enterprises_manager/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IAppAnalyticsDatasource appAnalyticsDatasource(Ref ref) {
  return AppAnalyticsDatasource(
    firebaseStorage: ref.watch(firebaseStorageProvider),
    localStorage: ref.watch(localStorageProvider),
  );
}

@riverpod
IAppAnalyticsRepository appAnalyticsRepository(Ref ref) {
  return AppAnalyticsRepositoryImpl(
    datasource: ref.watch(appAnalyticsDatasourceProvider),
    enterprisesManagerDatasource: ref.watch(
      enterprisesManagerDatasourceProvider,
    ),
  );
}

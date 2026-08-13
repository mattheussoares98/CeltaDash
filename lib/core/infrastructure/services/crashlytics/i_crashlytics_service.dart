import 'package:celta_dash/core/domain/entities/entities.dart';

abstract class ICrashlyticsService {
  Future<void> setCustomKeys(List<CrashlyticsCustomKeyEntity> customKeys);

  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace stackTrace,
    String? reason,
    List<CrashlyticsCustomKeyEntity>? customKeys,
  });
}

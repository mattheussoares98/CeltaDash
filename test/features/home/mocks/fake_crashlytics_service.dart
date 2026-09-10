import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';

class FakeCrashlyticsService implements ICrashlyticsService {
  const FakeCrashlyticsService();

  @override
  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace stackTrace,
    String? reason,
    List<CrashlyticsCustomKeyEntity>? customKeys,
  }) async {}

  @override
  Future<void> setCustomKeys(
    List<CrashlyticsCustomKeyEntity> customKeys,
  ) async {}
}

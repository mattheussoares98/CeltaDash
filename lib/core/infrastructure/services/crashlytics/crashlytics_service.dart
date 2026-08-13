import 'package:celta_dash/core/domain/entities/entities.dart';
import 'package:celta_dash/core/infrastructure/services/services.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService implements ICrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService(this._crashlytics);

  /// Sets custom keys for the current session
  @override
  Future<void> setCustomKeys(
    List<CrashlyticsCustomKeyEntity> customKeys,
  ) async {
    // Centralized platform check to avoid repeating logic in UI
    if (PlatformUtil.isDesktop || PlatformUtil.isWeb) {
      return;
    }

    await Future.wait(
      customKeys.map(
        (item) => _crashlytics.setCustomKey(item.key, item.value.toString()),
      ),
    );
  }

  @override
  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace stackTrace,
    String? reason,
    List<CrashlyticsCustomKeyEntity>? customKeys,
  }) async {
    if (PlatformUtil.isDesktop || PlatformUtil.isWeb) {
      return;
    }

    if (customKeys != null) {
      await setCustomKeys(customKeys);
      for (final item in customKeys) {
        await _crashlytics.log('${item.key}: ${item.value}');
      }
    }

    if (reason != null) {
      await _crashlytics.log('Reason: $reason');
    }

    await _crashlytics.recordError(exception, stackTrace, reason: reason);
  }
}

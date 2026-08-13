import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
ICrashlyticsService crashlyticsService(Ref ref) {
  return CrashlyticsService(FirebaseCrashlytics.instance);
}

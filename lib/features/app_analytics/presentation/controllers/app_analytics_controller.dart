// lib/features/app_analytics/presentation/controllers/app_analytics_controller.dart
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_analytics_controller.g.dart';

@riverpod
class AppAnalyticsController extends _$AppAnalyticsController {
  @override
  Future<List<AppAnalyticsEntity>> build(DateTime period) {
    ref.cache();
    return ref.read(appAnalyticsRepositoryProvider).getAnalytics(period);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(appAnalyticsRepositoryProvider).getAnalytics(period),
    );
  }
}

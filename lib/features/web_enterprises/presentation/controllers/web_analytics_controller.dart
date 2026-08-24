import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/web_enterprises/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_analytics_controller.g.dart';

@riverpod
class WebAnalyticsController extends _$WebAnalyticsController {
  @override
  Future<List<MonthlyAnalyticsEntity>> build(DateTime period) =>
      ref.read(webEnterprisesRepositoryProvider).getAnalytics(period);

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(webEnterprisesRepositoryProvider).getAnalytics(period),
    );
  }
}

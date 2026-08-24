import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_analytics_controller.g.dart';

@riverpod
class WebAnalyticsController extends _$WebAnalyticsController {
  @override
  Future<List<WebAnalyticsEntity>> build(DateTime period) {
    ref.cache();
    return ref.read(webEnterprisesRepositoryProvider).getAnalytics(period);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(webEnterprisesRepositoryProvider).getAnalytics(period),
    );
  }
}

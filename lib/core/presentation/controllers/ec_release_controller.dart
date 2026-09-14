import 'package:celta_dash/core/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ec_release_controller.g.dart';

@Riverpod(keepAlive: true)
class EcReleaseController extends _$EcReleaseController {
  @override
  Future<DateTime> build() async {
    final ecParams = await ref.watch(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) {
      throw Exception('No active EC parameters found.');
    }
    return ref.watch(ecReleaseRepositoryProvider).getReleasedAtUtc(ecParams);
  }
}

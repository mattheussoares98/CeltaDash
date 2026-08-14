import 'package:celta_dash/features/login/providers.dart';
import 'package:celta_dash/features/login/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_prefill_controller.g.dart';

@riverpod
class LoginPrefillController extends _$LoginPrefillController {
  @override
  Future<LoginPrefillState> build() async {
    final enterprise = await ref.watch(loginRepositoryProvider).loadLastLogin();
    return LoginPrefillState(
      enterpriseName: enterprise?.enterpriseName,
      username: enterprise?.bsUser?.name,
    );
  }
}

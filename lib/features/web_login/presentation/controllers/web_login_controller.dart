import 'package:celta_dash/features/web_login/presentation/models/models.dart';
import 'package:celta_dash/features/web_login/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_login_controller.g.dart';

@riverpod
class WebLoginController extends _$WebLoginController {
  @override
  Future<WebLoginState> build() async {
    final isAuthenticated = await ref
        .read(webLoginRepositoryProvider)
        .isLoggedIn();
    return WebLoginState(isAuthenticated: isAuthenticated);
  }

  Future<void> login({required String email, required String password}) async {
    final current = state.value ?? const WebLoginState();
    state = AsyncData(
      current.copyWith(isSubmitting: true, clearActionError: true),
    );

    try {
      await ref
          .read(webLoginRepositoryProvider)
          .login(email: email, password: password);
      state = AsyncData(
        current.copyWith(
          isAuthenticated: true,
          isSubmitting: false,
          clearActionError: true,
        ),
      );
    } catch (error) {
      state = AsyncData(
        current.copyWith(isSubmitting: false, actionError: error),
      );
    }
  }
}

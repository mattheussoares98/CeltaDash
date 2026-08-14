import 'package:celta_dash/features/splash/domain/domain.dart';
import 'package:celta_dash/features/splash/providers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_controller.g.dart';

@riverpod
class SplashController extends _$SplashController {
  @override
  FutureOr<SplashDestination> build() async {
    final repository = ref.watch(splashRepositoryProvider);

    // 1. Check if an app update is required
    final updateRequired = await repository.isUpdateRequired();
    if (updateRequired) {
      return SplashDestination.updateRequired;
    }

    // 2. Check saved session / enterprise
    final savedEnterprise = await repository.getSavedEnterprise();
    if (savedEnterprise != null) {
      EnterpriseBuilder.entity = savedEnterprise;

      final hasValidUser = savedEnterprise.bsUser?.name != null &&
          savedEnterprise.bsUser?.AccessKey != null &&
          savedEnterprise.bsUser?.CrossIdentity_Usuario != null;

      if (hasValidUser) {
        return SplashDestination.home;
      }
    }

    return SplashDestination.login;
  }
}

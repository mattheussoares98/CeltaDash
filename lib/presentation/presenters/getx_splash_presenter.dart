import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final NavigateTo navigateTo;
  final GetPlatformType getPlatform;

  GetxSplashPresenter({
    required this.navigateTo,
    required this.getPlatform,
  });

  @override
  Future<void> checkPageToGo({
    int durationInSeconds = 2,
    required EnterprisesManagerPresenter enterprisesManagerPresenter,
  }) async {
    try {
      await Future.delayed(Duration(seconds: durationInSeconds));

      final platform = getPlatform.get();
      if (platform == PlatformType.web) {
        navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true);
        return;
      }

      await enterprisesManagerPresenter.loadLocalEnterprises();

      final selectedEnterprise = EnterpriseBuilder.entity;
      if (selectedEnterprise?.bsUser?.name == null ||
          selectedEnterprise?.bsUser?.AccessKey == null ||
          selectedEnterprise?.bsUser?.CrossIdentity_Usuario == null) {
        navigateTo.navigate(pageRoute: PageRoutes.login, clear: true);
      } else {
        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } on DomainError catch (e) {
      switch (e) {
        default:
          navigateTo.navigate(pageRoute: PageRoutes.login, clear: true);
      }
    }
  }
}

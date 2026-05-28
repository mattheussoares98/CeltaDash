import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final NavigateTo navigateTo;
  final LoadDeviceData loadDeviceData;
  final FirebaseManager firebaseManager;

  GetxSplashPresenter({
    required this.navigateTo,
    required this.loadDeviceData,
    required this.firebaseManager,
  });

  @override
  Future<void> checkPageToGo({
    int durationInSeconds = 2,
    required EnterprisesManagerPresenter enterprisesManagerPresenter,
  }) async {
    try {
      await Future.delayed(Duration(seconds: durationInSeconds));

      final localVersion = await loadDeviceData.getAppVersion();
      final remoteVersion =
          await firebaseManager.get(path: "requiredVersion/version");

      final String remoteVersionNumber = remoteVersion.data() != null
          ? remoteVersion.data()["required"]
          : "0.0";

      if (localVersion.replaceAll(RegExp(r'\.'), '').toInt() <
          remoteVersionNumber.replaceAll(RegExp(r'\.'), '').toInt()) {
        navigateTo.navigate(
            pageRoute: PageRoutes.updateAppVersion, clear: true);
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

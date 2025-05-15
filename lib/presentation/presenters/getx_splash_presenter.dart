import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final NavigateTo navigateTo;
  final LocalStorage localStorage;
  final GetPlatformType getPlatform;

  GetxSplashPresenter({
    required this.navigateTo,
    required this.localStorage,
    required this.getPlatform,
  });

  @override
  Future<void> checkPageToGo({int durationInSeconds = 2}) async {
    try {
      await Future.delayed(Duration(seconds: durationInSeconds));

      final enterprise = await localStorage.get(DatabaseKeys.enterprise);
      if (enterprise != null) {
        EnterpriseBuilder.entity =
            FirebaseEnterpriseModel.fromJson(enterprise).toEntity();
      }

      if (EnterpriseBuilder.entity?.bsUser?.name == null ||
          EnterpriseBuilder.entity?.bsUser?.AccessKey == null ||
          EnterpriseBuilder.entity?.bsUser?.CrossIdentity_Usuario == null) {
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

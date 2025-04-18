import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final NavigateTo navigateTo;
  final LocalStorage localStorage;

  GetxSplashPresenter({required this.navigateTo, required this.localStorage});

  @override
  Future<void> checkPageToGo({int durationInSeconds = 2}) async {
    try {
      await Future.delayed(Duration(seconds: durationInSeconds));

      if (EnterpriseBuilder.entity?.user == null ||
          EnterpriseBuilder.entity?.accessKey == null) {
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

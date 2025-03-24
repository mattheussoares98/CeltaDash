import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final NavigateTo navigateTo;

  GetxSplashPresenter({required this.navigateTo});

  @override
  Future<void> checkPageToGo({
    int durationInSeconds = 2,
    required DateTime atualDate,
  }) async {
    try {
      await Future.delayed(Duration(seconds: durationInSeconds));
      navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
    } on DomainError catch (e) {
      switch (e) {
        default:
          navigateTo.navigate(pageRoute: PageRoutes.login, clear: true);
      }
    }
  }
}

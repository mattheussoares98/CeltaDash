import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebLoginPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebLoginPresenter {
  final NavigateTo navigateTo;
  final LoginManagement loginManagement;

  GetxWebLoginPresenter({
    required this.navigateTo,
    required this.loginManagement,
  });

  @override
  Future<void> doLogin({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      await loginManagement.login(email: email, password: password);
      await navigateTo.navigate(
        pageRoute: PageRoutes.webEnterprises,
        clear: true,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> doLogout() async {
    isLoading = true;
    mainError = null;
    try {
      await loginManagement.logout();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> navigateToWebConfigurationsPageIfAlreadyLoggedIn() async {
    isLoading = true;
    bool isLogged = await loginManagement.isLoggedIn();
    if (isLogged) {
      navigateTo.navigate(
          pageRoute: PageRoutes.webEnterprises, clear: true);
    }
    isLoading = false;
  }
}

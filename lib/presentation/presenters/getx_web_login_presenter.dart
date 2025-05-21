import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebLoginPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebLoginPresenter {
  final NavigateTo navigateTo;
  final FirebaseLoginManagement firebaseLoginManagement;

  GetxWebLoginPresenter({
    required this.navigateTo,
    required this.firebaseLoginManagement,
  });

  @override
  Future<void> doLogin({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      await firebaseLoginManagement.login(email: email, password: password);
      await navigateTo.navigate(pageRoute: PageRoutes.webEnterprises);
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
      await firebaseLoginManagement.logout();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> goToWebCustomersIfStillLogged() async {
    isLoading = true;
    bool isLogged = await firebaseLoginManagement.isLoggedIn();
    if (isLogged) {
      isLoading = false;
      navigateTo.navigate(pageRoute: PageRoutes.webEnterprises);
    } else {
      isLoading = false;
    }
  }
}

import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements LoginPresenter {
  final NavigateTo navigateTo;

  GetxLoginPresenter({
    required this.navigateTo,
  });

  @override
  Future<void> login({
    required String enterpriseName,
    required String user,
    required String password,
    required EnterprisesManagerPresenter enterprisesManagerPresenter,
  }) async {
    final added = await enterprisesManagerPresenter.addNewEnterprise(
      enterpriseName: enterpriseName,
      userName: user,
      userPassword: password,
    );

    if (added) {
      navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
    }
  }

  @override
  void goToWebLoginPage() {
    navigateTo.navigate(pageRoute: PageRoutes.webLogin);
  }
}

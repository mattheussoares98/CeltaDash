import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
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
    mainError = null;
    isLoading = true;
    try {
      final added = await enterprisesManagerPresenter.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: user,
        userPassword: password,
      );

      if (added) {
        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void onChangedEnterpriseName() {
    //TODO remove this function
    final oldEnterprise = EnterpriseBuilder.entity;

    EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
      baseUrl: null,
      firebaseSubEnterprises: null,
      enterpriseName: oldEnterprise?.enterpriseName,
      firebaseId: null,
      bsUser: BsUserEntity(
        name: oldEnterprise?.bsUser?.name,
        AccessKey: null,
        CrossIdentity_Usuario: null,
      ),
    );
  }

  @override
  void goToWebLoginPage() {
    navigateTo.navigate(pageRoute: PageRoutes.webLogin);
  }
}

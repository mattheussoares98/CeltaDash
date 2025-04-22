import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements LoginPresenter {
  final NavigateTo navigateTo;
  final RemoteLogin remoteLogin;
  final FirebaseManager firebaseManager;
  final LocalStorage localStorage;

  GetxLoginPresenter({
    required this.navigateTo,
    required this.remoteLogin,
    required this.firebaseManager,
    required this.localStorage,
  });

  @override
  Future<void> login({
    required String enterpriseName,
    required String user,
    required String password,
    required void Function(String error) showBsErrorMessage,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      if (EnterpriseBuilder.entity?.ccsUrl == null) {
        final enterprise = await firebaseManager.get(
          collection: "enterprises",
          doc: enterpriseName.toLowerCase().removeWhiteSpaces(),
        );
        final enterpriseData = enterprise.data();

        EnterpriseBuilder.entity = EnterpriseEntity(
          ccsUrl: enterpriseData["ccsUrl"],
          bsUser: BsUserEntity(
            name: user,
            AccessKey: null,
            CrossIdentity_Usuario: null,
          ),
          enterpriseName: enterpriseName,
        );
      }

      final response = await remoteLogin.login(user: user, password: password);

      if (response.responseType == SoapResponseType.error) {
        showBsErrorMessage(response.response);
      } else {
        EnterpriseBuilder.entity = EnterpriseEntity(
          ccsUrl: EnterpriseBuilder.entity?.ccsUrl,
          bsUser: BsUserEntity(
            name: user,
            AccessKey: response.response["AccessKey"],
            CrossIdentity_Usuario: response.response["CrossIdentity_Usuario"],
          ),
          enterpriseName: enterpriseName,
        );

        await localStorage.put(
          DatabaseKeys.enterprise,
          EnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson(),
        );
        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateChangedEnterpriseName() {}
}

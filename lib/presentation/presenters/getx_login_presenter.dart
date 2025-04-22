import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
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
      final enterprise = await firebaseManager.get(
        collection: "enterprises",
        doc: enterpriseName.toLowerCase().removeWhiteSpaces(),
      );

      final enterpriseData = enterprise.data();
      _changedEnterpriseName = false;

      EnterpriseBuilder.entity = EnterpriseEntity(
        ccsUrl: enterpriseData["ccsUrl"],
        bsUser: BsUserEntity(
          name: user,
          accessKey: null,
        ),
        enterpriseName: enterpriseName,
      );
      //TODO create test to change enterprise correctly

      final response = await remoteLogin.login(user: user, password: password);

      if (response.responseType == SoapResponseType.error) {
        showBsErrorMessage(response.response);
      } else {
        EnterpriseBuilder.entity = EnterpriseEntity(
          ccsUrl: EnterpriseBuilder.entity?.ccsUrl, //TODO change to ccsUrl
          //TODO add enterpriseName. Move user and accessKey to another entity
          bsUser: BsUserEntity(
            name: user,
            accessKey: enterpriseData["accessKey"],
          ),
          enterpriseName: enterpriseName,
        );
        //TODO create test to change enterprise correctly

        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  bool _changedEnterpriseName = false;
  @override
  bool get changedEnterpriseName => _changedEnterpriseName;

  @override
  void updateChangedEnterpriseName(bool value) {
    _changedEnterpriseName = value;
  }
}

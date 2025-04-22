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

  GetxLoginPresenter({
    required this.navigateTo,
    required this.remoteLogin,
    required this.firebaseManager,
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
        doc: enterpriseName,
      );

      final enterpriseData = enterprise.data();

      EnterpriseBuilder.entity = EnterpriseEntity(
        url: enterpriseData["ccsUrl"],
        user: user,
        accessKey: "",
      );

      final response = await remoteLogin.login(user: user, password: password);

      if (response.responseType == SoapResponseType.error) {
        showBsErrorMessage(response.response);
      } else {
        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}

import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
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
  final BsLogin bsLogin;
  final FirebaseManager firebaseManager;
  final LocalStorage localStorage;

  GetxLoginPresenter({
    required this.navigateTo,
    required this.bsLogin,
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
      if (EnterpriseBuilder.entity?.baseUrl == null) {
        final enterprise = await firebaseManager.get(
          collection: "enterprises",
          doc: enterpriseName.toLowerCase().removeWhiteSpaces(),
        );

        final enterpriseData = enterprise.data();
        if (enterpriseData == null) {
          throw DomainError.enterpriseNotFound;
        }

        EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
          baseUrl: enterpriseData["baseUrl"],
          firebaseId: enterprise.id,
          enterpriseName: enterpriseName,
          bsUser: BsUserEntity(
            name: user.trimRight(),
            AccessKey: null,
            CrossIdentity_Usuario: null,
          ),
          firebaseSubEnterprises: enterpriseData["subEnterprises"]
              ?.map<FirebaseSubEnterpriseEntity>(
                  (e) => FirebaseSubEnterpriseModel.fromJson(e).toEntity())
              .toList(),
        );
      }

      final response = await bsLogin.login(
        user: user.trimRight(),
        password: password,
      );

      if (response.responseType == SoapResponseType.error) {
        showBsErrorMessage(response.response);
      } else if (response.response["AccessKey"] == null) {
        throw DomainError.updateCeltaBs;
      } else {
        EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
          baseUrl: EnterpriseBuilder.entity?.baseUrl,
          firebaseSubEnterprises:
              EnterpriseBuilder.entity?.firebaseSubEnterprises,
          firebaseId: EnterpriseBuilder.entity?.firebaseId,
          bsUser: BsUserEntity(
            name: user.trimRight(),
            AccessKey: response.response["AccessKey"],
            CrossIdentity_Usuario: response.response["CrossIdentity_Usuario"],
          ),
          enterpriseName: enterpriseName,
        );

        await localStorage.put(
          DatabaseKeys.enterprise,
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toJson(),
        );
        navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
      }
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.enterpriseNotFound:
          mainError = UIError.enterpriseNotFound;
          break;
        case DomainError.updateCeltaBs:
          mainError = UIError.updateCeltaBs;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void onChangedEnterpriseName() {
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

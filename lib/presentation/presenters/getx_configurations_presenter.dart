import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxConfigurationsPresenter extends GetxController
    with UIErrorManager, LoadingManager
    implements ConfigurationsPresenter {
  final NavigateTo navigateTo;
  final LocalStorage localStorage;

  GetxConfigurationsPresenter({
    required this.navigateTo,
    required this.localStorage,
  });

  @override
  Future<void> doLogout() async {
    isLoading = true;
    mainError = null;
    try {
      final oldEnterprise = EnterpriseBuilder.entity;

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: null,
        enterpriseName: oldEnterprise?.enterpriseName,
        firebaseId: null,
        bsUser: BsUserEntity(
          name: oldEnterprise?.bsUser?.name,
          AccessKey: null,
          CrossIdentity_Usuario: null,
        ),
        firebaseSubEnterprises: null,
      );

      await localStorage.put(
          DatabaseKeys.enterprise,
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toJson());

      navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}

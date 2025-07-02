import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxEnterprisesManagerPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements EnterprisesManagerPresenter {
  final NavigateTo navigateTo;
  final BsLogin bsLogin;
  final FirebaseManager firebaseManager;
  final LocalStorage localStorage;

  GetxEnterprisesManagerPresenter({
    required this.navigateTo,
    required this.bsLogin,
    required this.firebaseManager,
    required this.localStorage,
  });

  final _selectedEnterprise = Rx<FirebaseEnterpriseViewModel?>(null);
  @override
  FirebaseEnterpriseViewModel? get selectedEnterprise =>
      _selectedEnterprise.value;
  @override
  set selectedEnterprise(FirebaseEnterpriseViewModel? value) =>
      _selectedEnterprise.value = value;

  @override
  Future<void> updateSelectedEnterprise(
    FirebaseEnterpriseViewModel? enterprise,
  ) async {
    _selectedEnterprise.value = enterprise;

    if (enterprise == null) {
      await localStorage.delete(DatabaseKeys.selectedEnterprise);
    } else {
      await localStorage.put(
        DatabaseKeys.selectedEnterprise,
        FirebaseEnterpriseModel.fromViewModel(enterprise).toJson(),
      );
    }
  }

  @override
  Future<void> loadLocalEnterprises() async {
    isLoading = true;
    mainError = null;

    try {
      final localOldEnterprise =
          await localStorage.get(DatabaseKeys.enterprise);

      if (localOldEnterprise != null && localOldEnterprise != "") {
        selectedEnterprise =
            FirebaseEnterpriseModel.fromJson(localOldEnterprise).toViewModel();
      } else {
        final localSelectedEnterprise =
            await localStorage.get(DatabaseKeys.selectedEnterprise);

        if (localSelectedEnterprise != null && localSelectedEnterprise != "") {
          selectedEnterprise =
              FirebaseEnterpriseModel.fromJson(localSelectedEnterprise)
                  .toViewModel();
        }
      }

      localStorage.delete(DatabaseKeys
          .enterprise); //TODO delete this key in the future, wont use more
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}

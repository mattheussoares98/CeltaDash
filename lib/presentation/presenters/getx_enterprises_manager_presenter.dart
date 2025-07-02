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

    await localStorage.put(
      DatabaseKeys.selectedEnterprise,
      FirebaseEnterpriseModel.fromViewModel(enterprise!).toJson(),
    );
  }
}

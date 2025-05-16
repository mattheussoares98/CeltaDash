import 'package:celta_plus/ui/pages/web_enterprises/firebase_enterprise_view_model.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebEnterprisesPresenter {
  final NavigateTo navigateTo;
  final FirebaseManager firebaseManager;

  GetxWebEnterprisesPresenter({
    required this.navigateTo,
    required this.firebaseManager,
  });

  @override
  Future<void> getCustomers() async {
    isLoading = true;
    mainError = null;
    try {
      final enterprises = await firebaseManager.get(collection: "enterprises");
      final data = enterprises.data();
      // List<FirebaseSubEnterpriseEntity>? firebaseSubEnterprises = enterprises
      //     .data()["subEnterprises"]
      //     ?.map<FirebaseSubEnterpriseEntity>(
      //         (e) => FirebaseSubEnterpriseModel.fromJson(e).toEntity())
      //     .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final Rx<List<FirebaseEnterpriseViewModel>?> _enterprises = Rx(null);
  @override
  Stream<List<FirebaseEnterpriseViewModel>?> get enterprisesStream =>
      _enterprises.stream;
  set enterprises(List<FirebaseEnterpriseViewModel>? enterprises) =>
      _enterprises.value = enterprises;
}

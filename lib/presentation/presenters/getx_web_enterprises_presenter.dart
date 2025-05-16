import 'package:get/get.dart';

import '../../data/models/models.dart';
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
  Future<void> getEnterprises() async {
    isLoading = true;
    mainError = null;
    try {
      final remoteEnterprises =
          await firebaseManager.get(collection: "enterprises");

      enterprises = remoteEnterprises.docs
          .map<FirebaseEnterpriseViewModel>((e) =>
              FirebaseEnterpriseModel.fromJson(e.data(), documentId: e.id)
                  .toViewModel())
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _enterprises = Rx<List<FirebaseEnterpriseViewModel>?>(null);
  @override
  Stream<List<FirebaseEnterpriseViewModel>?> get enterprisesStream =>
      _enterprises.stream;
  set enterprises(List<FirebaseEnterpriseViewModel>? enterprises) =>
      _enterprises.value = enterprises;

  @override
  void goToEnterpriseDetails() {
    navigateTo.navigate(pageRoute: PageRoutes.webEnterpriseDetails);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
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
  void goToEnterpriseDetails(FirebaseEnterpriseViewModel enterprise) {
    _selectedEnterprise = enterprise;
    navigateTo.navigate(pageRoute: PageRoutes.webEnterpriseDetails);
  }

  FirebaseEnterpriseViewModel? _selectedEnterprise;
  @override
  FirebaseEnterpriseViewModel? get selectedEnterprise => _selectedEnterprise;

  @override
  Future<void> changeEnterpriseUrl({
    required String newUrl,
    required DocumentReference<Map<String, dynamic>> docRef,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      await firebaseManager.put(
        documentReference: docRef,
        data: {"baseUrl": newUrl},
        merge: true,
      );

      _selectedEnterprise = FirebaseEnterpriseViewModel(
        baseUrl: newUrl,
        enterpriseName: _selectedEnterprise?.enterpriseName,
        firebaseSubEnterprises: _selectedEnterprise?.firebaseSubEnterprises,
        firebaseId: _selectedEnterprise?.firebaseId,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}

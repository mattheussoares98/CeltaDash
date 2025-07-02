import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../ui/helpers/helpers.dart';
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

  final _allEnterprises = Rx<List<FirebaseEnterpriseViewModel>?>(null);
  @override
  List<FirebaseEnterpriseViewModel>? get allEnterprises =>
      _allEnterprises.value;
  @override
  set allEnterprises(List<FirebaseEnterpriseViewModel>? value) =>
      _allEnterprises.value = value;

  @override
  Future<void> updateSelectedEnterprise(
    FirebaseEnterpriseViewModel enterprise,
  ) async {
    _selectedEnterprise.value = enterprise;

    await localStorage.put(
      DatabaseKeys.enterprise,
      FirebaseEnterpriseModel.fromViewModel(enterprise).toJson(),
    );
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
      }
      localStorage.delete(DatabaseKeys.enterprise);
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<bool> addNewEnterprise({
    required String enterpriseName,
    required String userName,
    required String userPassword,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (_allEnterprises.value?.any((e) =>
              e.enterpriseName?.toLowerCase().removeWhiteSpaces() ==
              enterpriseName.toLowerCase().removeWhiteSpaces()) ??
          false) {
        throw DomainError.enterpriseAlreadyExists;
      }

      final enterprise = await firebaseManager.get(
        collection: "enterprises",
        doc: enterpriseName.toLowerCase().removeWhiteSpaces(),
      );

      final enterpriseData = enterprise.data();
      if (enterpriseData == null) {
        throw DomainError.enterpriseNotFound;
      }

      final response = await bsLogin.login(
        user: userName.trimRight(),
        password: userPassword,
        url: enterpriseData["baseUrl"],
      );

      if (response["AccessKey"] == null) {
        throw DomainError.updateCeltaBs;
      }

      final newEnterprise = FirebaseEnterpriseEntity(
        baseUrl: enterpriseData["baseUrl"],
        firebaseId: enterprise.id,
        enterpriseName: enterpriseName.trimRight(),
        bsUser: BsUserEntity(
          name: userName.trimRight(),
          AccessKey: response["AccessKey"],
          CrossIdentity_Usuario: response["CrossIdentity_Usuario"],
        ),
        firebaseSubEnterprises: (enterpriseData["subEnterprises"] as List?)
            ?.map<FirebaseSubEnterpriseEntity>(
                (e) => FirebaseSubEnterpriseModel.fromJson(e).toEntity())
            .toList(),
      );

      allEnterprises = [
        ...?_allEnterprises.value,
        FirebaseEnterpriseModel.fromEntity(newEnterprise).toViewModel(),
      ];

      await localStorage.put(
        DatabaseKeys.allEnterprises,
        _allEnterprises.value
            ?.map((e) => FirebaseEnterpriseModel.fromViewModel(e).toJson())
            .toList(),
      );

      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
    } finally {
      isLoading = false;
    }
  }
}

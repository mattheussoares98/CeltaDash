import 'package:celta_dash/utils/utils.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements WebEnterprisesPresenter {
  final NavigateTo navigateTo;
  final FirebaseManager firebaseManager;
  final BsLogin bsLogin;
  final LoadEnterprises loadEnterprises;

  GetxWebEnterprisesPresenter({
    required this.navigateTo,
    required this.firebaseManager,
    required this.bsLogin,
    required this.loadEnterprises,
  });

  @override
  Future<void> getEnterprises() async {
    isLoading = true;
    mainError = null;
    try {
      final remoteEnterprises = await firebaseManager.get(path: "enterprises");

      enterprises = remoteEnterprises.docs
          .map<FirebaseEnterpriseViewModel>((e) =>
              FirebaseEnterpriseModel.fromJson(e.data(), documentId: e.id)
                  .toViewModel())
          .toList();
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  final _enterprises = Rx<List<FirebaseEnterpriseViewModel>?>(null);
  @override
  List<FirebaseEnterpriseViewModel>? get enterprises => _enterprises.value;
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
  Future<void> changeEnterpriseUrl(String newUrl) async {
    isLoading = true;
    mainError = null;
    try {
      if (newUrl == _selectedEnterprise?.baseUrl) {
        throw DomainError.sameUrl;
      }

      await firebaseManager.put(
        path: "enterprises/${_selectedEnterprise?.firebaseId}",
        data: {"baseUrl": newUrl},
        merge: true,
      );

      _selectedEnterprise = FirebaseEnterpriseViewModel(
        baseUrl: newUrl,
        enterpriseName: _selectedEnterprise?.enterpriseName,
        firebaseSubEnterprises: _selectedEnterprise?.firebaseSubEnterprises,
        firebaseId: _selectedEnterprise?.firebaseId,
        bsUser: _selectedEnterprise?.bsUser,
      );

      int? index = _enterprises.value
          ?.indexWhere((e) => e.firebaseId == _selectedEnterprise?.firebaseId);

      if (index != null && index != -1) {
        final oldEnterprises = [..._enterprises.value!];
        oldEnterprises[index] = _selectedEnterprise!;
        _enterprises.value = oldEnterprises;
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> addNewEnterprise({
    required String baseUrl,
    required String enterpriseName,
    required String bsUserName,
    required String bsPassword,
    required void Function() doOnSucceeds,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (_enterprises.value?.any((e) =>
              e.enterpriseName?.toLowerCase().removeWhiteSpaces() ==
              enterpriseName.toLowerCase().removeWhiteSpaces()) ??
          false) {
        throw DomainError.enterpriseAlreadyExists;
      }

      final loginResult = await bsLogin.login(
        user: bsUserName,
        password: bsPassword,
        url: baseUrl.toLowerCase().removeWhiteSpaces(),
      );

      BsUserModel bsUser = BsUserModel.fromJson(loginResult);

      if (bsUser.AccessKey == null) {
        throw DomainError.updateCeltaBs;
      }
      final enterprises = await loadEnterprises.get(
        url: baseUrl.toLowerCase().removeWhiteSpaces(),
        accessKey: bsUser.AccessKey,
        userName: bsUserName,
      );

      await firebaseManager.put(
        path: "enterprises/${enterpriseName.toLowerCase().removeWhiteSpaces()}",
        data: {
          "baseUrl": baseUrl.toLowerCase().removeWhiteSpaces(),
          "enterpriseName": enterpriseName.toLowerCase().removeWhiteSpaces(),
          "subEnterprises": enterprises
              .map((e) => EnterpriseModel.fromEntity(e).toJson())
              .toList(),
        },
      ).timeout(const Duration(seconds: 30));

      final oldEnterprises = [...?_enterprises.value];
      _enterprises.value = [
        ...oldEnterprises,
        FirebaseEnterpriseViewModel(
          baseUrl: baseUrl.toLowerCase().removeWhiteSpaces(),
          enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
          bsUser: bsUser,
          firebaseSubEnterprises: enterprises
              .map(
                (e) => FirebaseSubEnterpriseViewModel(
                  id: enterpriseName,
                  name: e.name,
                  personalizedCode: e.personalizedCode,
                  cnpj: e.cnpj,
                  enabled: false
                      .toString(), //adding new enterprise, need to add as false value
                ),
              )
              .toList(),
          firebaseId: enterpriseName.toLowerCase().removeWhiteSpaces(),
        ),
      ];

      doOnSucceeds();
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToLoginPage() {
    navigateTo.navigate(pageRoute: PageRoutes.login, clear: true);
  }

  @override
  Future<bool> changeEnterpriseIsEnabled(int subEnterpriseIndex) async {
    isLoading = true;
    mainError = null;
    try {
      final oldSelectedEnterprise = _selectedEnterprise;
      final oldSubEnterprise =
          _selectedEnterprise?.firebaseSubEnterprises?[subEnterpriseIndex];
      final oldSubenterpriseUpdated = FirebaseSubEnterpriseViewModel(
        id: oldSubEnterprise?.id,
        name: oldSubEnterprise?.name,
        personalizedCode: oldSubEnterprise?.personalizedCode,
        cnpj: oldSubEnterprise?.cnpj,
        enabled: oldSubEnterprise?.enabled == "true" ? "false" : "true",
      );
      oldSelectedEnterprise?.firebaseSubEnterprises?[subEnterpriseIndex] =
          oldSubenterpriseUpdated;

      final firebaseEnterpriseUpdated = FirebaseEnterpriseViewModel(
        baseUrl: _selectedEnterprise?.baseUrl,
        enterpriseName: _selectedEnterprise?.enterpriseName,
        firebaseId: _selectedEnterprise?.firebaseId,
        bsUser: _selectedEnterprise?.bsUser,
        firebaseSubEnterprises: oldSelectedEnterprise?.firebaseSubEnterprises,
      );

      await firebaseManager.put(
        path: "enterprises/${_selectedEnterprise?.firebaseId}",
        data: FirebaseEnterpriseModel.fromViewModel(firebaseEnterpriseUpdated)
            .toJson(),
        merge: false,
      );

      _selectedEnterprise = firebaseEnterpriseUpdated;
      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
    } finally {
      isLoading = false;
    }
  }
}

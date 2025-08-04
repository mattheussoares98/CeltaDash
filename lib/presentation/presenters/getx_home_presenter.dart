import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter extends GetxController
    with ErrorHandling, UIErrorManager, LoadingManager
    implements HomePresenter {
  final NavigateTo navigateTo;
  final LoadEnterprises loadEnterprises;
  final FirebaseManager firebaseManager;
  final LocalStorage localStorage;

  GetxHomePresenter({
    required this.navigateTo,
    required this.loadEnterprises,
    required this.firebaseManager,
    required this.localStorage,
  });

  @override
  void updateSelectedIndex(int index) {
    _currentPageIndex.value = index;
  }

  @override
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
  }

  List<FirebaseSubEnterpriseEntity> _getMissingEnterprises(
    List<EnterpriseEntity> enterprises,
    List<FirebaseSubEnterpriseEntity> enterprisesToCompare,
  ) {
    return enterprises
        .where((e) {
          return !enterprisesToCompare
              .any((sub) => sub.cnpj == e.cnpj && sub.id == e.id);
        })
        .map(
          (e) => FirebaseSubEnterpriseEntity(
            id: e.id,
            name: e.name,
            personalizedCode: e.personalizedCode,
            cnpj: e.cnpj,
            enabled: false, //adding new enterprise, need to add as false value
          ),
        )
        .toList();
  }

  @override
  Future<void> getBsEnterprises() async {
    isLoading = true;
    mainError = null;
    try {
      final enterprisesInBs = await loadEnterprises.get();

      final missingLocal = _getMissingEnterprises(
        enterprisesInBs,
        EnterpriseBuilder.entity?.firebaseSubEnterprises ?? [],
      );

      if (missingLocal.isNotEmpty) {
        final docPath = "enterprises/${EnterpriseBuilder.entity!.firebaseId}";
        final firebaseEnterprise = await firebaseManager.get(path: docPath);

        List<FirebaseSubEnterpriseEntity>? firebaseSubEnterprises =
            firebaseEnterprise
                .data()["subEnterprises"]
                ?.map<FirebaseSubEnterpriseEntity>(
                    (e) => FirebaseSubEnterpriseModel.fromJson(e).toEntity())
                .toList();

        final missingRemote = _getMissingEnterprises(
          enterprisesInBs,
          firebaseSubEnterprises ?? [],
        );

        if (missingRemote.isNotEmpty) {
          await firebaseManager.put(
            path: docPath,
            arrayUnion: [
              {
                "subEnterprises": FieldValue.arrayUnion(
                  missingLocal
                      .map((e) =>
                          FirebaseSubEnterpriseModel.fromEntity(e).toJson())
                      .toList(),
                ),
              }
            ],
            data: {},
            merge: true,
          );
          EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
            baseUrl: EnterpriseBuilder.entity?.baseUrl,
            enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
            bsUser: EnterpriseBuilder.entity?.bsUser,
            firebaseSubEnterprises: [
              ...?firebaseSubEnterprises,
              ...missingLocal,
            ],
            firebaseId: EnterpriseBuilder.entity?.firebaseId,
          );
          await localStorage.put(
              DatabaseKeys.enterprise,
              FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
                  .toJson());
        }
      }

      _bsEnterprises.value = enterprisesInBs
          .map((e) => EnterpriseModel.fromEntity(e).toViewModel())
          .toList();
      selectedEnterprise = _bsEnterprises.value?.first;
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedEnterprise(EcEnterpriseViewModel? enterprise) {
    mainError = null;
    int? index = EnterpriseBuilder.entity?.firebaseSubEnterprises
        ?.indexWhere((e) => e.id == enterprise?.id?.toInt());

    if (index == null || index == -1) {
      mainError = UIError.unexpected;
      return;
    }

    if (EnterpriseBuilder.entity?.firebaseSubEnterprises?[index].enabled ==
        true) {
      selectedEnterprise = enterprise;
    } else {
      mainError = UIError.disabledEnterprise;
    }
  }

  final _selectedEnterprise = Rx<EcEnterpriseViewModel?>(null);
  @override
  EcEnterpriseViewModel? get selectedEnterprise => _selectedEnterprise.value;
  set selectedEnterprise(EcEnterpriseViewModel? enterprise) {
    _selectedEnterprise.value = enterprise;

    int? subEnterpriseIndex = EnterpriseBuilder.entity?.firebaseSubEnterprises
        ?.indexWhere((e) => e.id == enterprise?.id?.toInt());

    if (subEnterpriseIndex != null && subEnterpriseIndex != -1) {
      bool isEnabled = EnterpriseBuilder
              .entity?.firebaseSubEnterprises?[subEnterpriseIndex].enabled ??
          false;

      selectedEnterpriseIsEnabled = isEnabled;
      if (isEnabled == false) {
        updateSelectedIndex(0);
      }
    } else {
      selectedEnterpriseIsEnabled = true;
    }
  }

  final Rx<List<EcEnterpriseViewModel>?> _bsEnterprises =
      Rx<List<EcEnterpriseViewModel>?>(null);

  @override
  List<EcEnterpriseViewModel>? get enterprises => _bsEnterprises.value;

  @override
  int get currentPageIndex => _currentPageIndex.value;
  final _currentPageIndex = 0.obs;

  DateTime _selectedDate = DateTime.now();
  @override
  DateTime get selectedDate => _selectedDate;

  StreamSubscription<DocumentSnapshot>? _firebaseSub;
  @override
  void initFirebaseStream() {
    final id = EnterpriseBuilder.entity?.firebaseId;
    if (id == null) return;

    _firebaseSub?.cancel(); // Ensure previous listener is cancelled
    _firebaseSub = FirebaseFirestore.instance
        .collection("enterprises")
        .doc(id)
        .snapshots()
        .listen((snapshot) async {
      if (!snapshot.exists || snapshot.data() == null) return;

      final oldEnterprise = EnterpriseBuilder.entity;
      final newEnteprise =
          FirebaseEnterpriseModel.fromJson(snapshot.data()!).toEntity();
      final newSubEnterprises = newEnteprise.firebaseSubEnterprises;

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: newEnteprise.baseUrl ?? oldEnterprise?.baseUrl,
        enterpriseName:
            newEnteprise.enterpriseName ?? oldEnterprise?.enterpriseName,
        bsUser: oldEnterprise?.bsUser,
        firebaseId: newEnteprise.firebaseId ?? oldEnterprise?.firebaseId,
        firebaseSubEnterprises: newSubEnterprises,
      );

      await localStorage.put(
        DatabaseKeys.enterprise,
        FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson(),
      );

      selectedEnterprise = _selectedEnterprise.value;
    });
  }

  @override
  void onInit() {
    super.onInit();
    initFirebaseStream();
  }

  @override
  void onClose() {
    super.onClose();
    _firebaseSub?.cancel();
    _firebaseSub = null;
  }

  @override
  void goToOperatorsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.operators);
  }

  @override
  void goToSellersPage() {
    navigateTo.navigate(pageRoute: PageRoutes.sellers);
  }

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
      await localStorage.delete(DatabaseKeys.allEnterprises);

      navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void reloadSales(
    ResumePresenter resumePresenter,
    SalesPresenter salesPresenter,
    ProductsPresenter productsPresenter, {
    required DateTime now,
    bool? forceRefresh,
  }) {
    resumePresenter.getSales(this, forceRefresh: forceRefresh, now: now);
    salesPresenter.getSales(this, forceRefresh: forceRefresh);
    productsPresenter.getSales(this, forceRefresh: forceRefresh);
  }

  @override
  void goToCanceledSalesPage() {
    navigateTo.navigate(pageRoute: PageRoutes.canceledSales);
  }

  @override
  void goToCompareDays() {
    navigateTo.navigate(pageRoute: PageRoutes.compareDays);
  }

  @override
  void goToDepartmentsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.departments);
  }

  @override
  void goToPaymentsTypePage() {
    navigateTo.navigate(pageRoute: PageRoutes.paymentsType);
  }

  @override
  void goToEnterprisesManagerPage() {
    navigateTo.navigate(pageRoute: PageRoutes.enterprisesManager);
  }

  @override
  void goToNotCanceledSalesPage() {
    navigateTo.navigate(pageRoute: PageRoutes.notCanceledSales);
  }

  final _selectedEnterpriseIsEnabled = false.obs;
  @override
  bool get selectedEnterpriseIsEnabled => _selectedEnterpriseIsEnabled.value;
  set selectedEnterpriseIsEnabled(bool value) {
    _selectedEnterpriseIsEnabled.subject.add(value);
    _selectedEnterpriseIsEnabled.value = value;
  }

  bool get selectedEnterpriseIsEnabledValue =>
      _selectedEnterpriseIsEnabled.value;
}

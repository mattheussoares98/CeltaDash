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
    with UIErrorManager, LoadingManager, UpdateScreenManager
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
    _currentPageIndex.subject.add(index);
  }

  @override
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    updateScreen();
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
  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
    required DocumentReference<Map<String, dynamic>> docRef,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final enterprisesInBs = await loadEnterprises.get();

      final missingLocal = _getMissingEnterprises(
        enterprisesInBs,
        EnterpriseBuilder.entity?.firebaseSubEnterprises ?? [],
      );

      if (missingLocal.isNotEmpty) {
        final firebaseEnterprise = await firebaseManager.get(
          collection: "enterprises",
          doc: EnterpriseBuilder.entity?.firebaseId,
        );

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
            documentReference: docRef,
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
      _selectedEnterprise.value = _bsEnterprises.value?.first;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedEnterprise(EnterpriseViewModel? enterprise) {
    mainError = null;
    int? index = EnterpriseBuilder.entity?.firebaseSubEnterprises
        ?.indexWhere((e) => e.id == enterprise?.id?.toInt());

    if (index == null || index == -1) {
      mainError = UIError.unexpected;
      return;
    }

    if (EnterpriseBuilder.entity?.firebaseSubEnterprises?[index].enabled ==
        true) {
      _selectedEnterprise.value = enterprise;
      updateScreen();
    } else {
      mainError = UIError.disabledEnterprise;
    }
  }

  final _selectedEnterprise = Rx<EnterpriseViewModel?>(null);
  @override
  EnterpriseViewModel? get selectedEnterprise => _selectedEnterprise.value;

  final Rx<List<EnterpriseViewModel>?> _bsEnterprises =
      Rx<List<EnterpriseViewModel>?>(null);

  @override
  List<EnterpriseViewModel>? get enterprises => _bsEnterprises.value;

  @override
  Stream<int> get currentPageIndexStream => _currentPageIndex.stream;

  final _currentPageIndex = 0.obs;

  DateTime _selectedDate = DateTime.now();
  @override
  DateTime get selectedDate => _selectedDate;

  @override
  void updateScreen() {
    needUpdateScreen = true;
    Future.delayed(Duration(milliseconds: 1), () {
      needUpdateScreen = false;
    });
  }

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
        .listen((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return;

      final oldEnterprise = EnterpriseBuilder.entity;
      final newSubEnterprises = FirebaseEnterpriseModel.fromJson(
        snapshot.data()!,
      ).toEntity().firebaseSubEnterprises;

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: oldEnterprise?.baseUrl,
        enterpriseName: oldEnterprise?.enterpriseName,
        bsUser: oldEnterprise?.bsUser,
        firebaseId: oldEnterprise?.firebaseId,
        firebaseSubEnterprises: newSubEnterprises,
      );

      updateScreen(); // Trigger update if needed
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

      navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToProfitabilityPage() {
    navigateTo.navigate(pageRoute: PageRoutes.profitability);
  }
}

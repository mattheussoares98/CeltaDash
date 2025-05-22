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

  @override
  void goToMorePage() {
    navigateTo.navigate(pageRoute: PageRoutes.more);
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
    _selectedEnterprise.value = enterprise;
    updateScreen();
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

  @override
  void reloadAllData(
    SalesPresenter salesPresenter,
    ResumePresenter resumePresenter,
    PaymentTypePresenter paymentTypePresenter,
    ProductsPresenter productsPresenter,
    DepartmentsPresenter departmentsPresenter, {
    bool? forceRefresh,
  }) {
    salesPresenter.getSales(
      homePresenter: this,
      resumePresenter: resumePresenter,
      forceRefresh: forceRefresh,
    );
    resumePresenter.getSales(this, forceRefresh: forceRefresh);
    paymentTypePresenter.getSales(this, forceRefresh: forceRefresh);
    productsPresenter.loadProducts(this, forceRefresh: forceRefresh);
    departmentsPresenter.getSales(this, forceRefresh: forceRefresh);
  }
}

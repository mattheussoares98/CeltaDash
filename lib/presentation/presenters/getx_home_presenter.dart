import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter extends GetxController
    with UIErrorManager, LoadingManager, UpdateScreenManager
    implements HomePresenter {
  final NavigateTo navigateTo;
  final LoadEnterprises loadEnterprises;
  final FirebaseManager firebaseManager;

  GetxHomePresenter({
    required this.navigateTo,
    required this.loadEnterprises,
    required this.firebaseManager,
  });

  @override
  void updateSelectedIndex(int index) {
    _currentPageIndex.value = index;
  }

  @override
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    updateScreen();
  }

  @override
  void goToConfigurationsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.configurations);
  }

  @override
  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final enterprises = await loadEnterprises.get();

      // final subEnterprises = EnterpriseBuilder.entity?.subEnterprises ?? [];
      // final missingEnterprises = enterprises.where((e) {
      //   return !subEnterprises
      //       .any((sub) => sub.cnpj == e.cnpj && sub.id == e.id);
      // }).toList();

      // if (missingEnterprises.isNotEmpty) {
      //   //TODO add missing enterprises in firebase
      //   await firebaseManager.put(
      //     documentReference: FirebaseFirestore.instance.collection("enterprises").doc(
      //       EnterpriseBuilder.entity.
      //     ),
      //     data: data,
      //     merge: true,
      //   );
      // }

      _bsEnterprises.value = enterprises
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

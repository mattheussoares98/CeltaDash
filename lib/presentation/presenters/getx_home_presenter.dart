import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter extends GetxController
    with UIErrorManager, LoadingManager
    implements HomePresenter {
  final NavigateTo navigateTo;
  final LoadEnterprises loadEnterprises;

  GetxHomePresenter({
    required this.navigateTo,
    required this.loadEnterprises,
  });

  @override
  void updateSelectedIndex(int index) {
    _currentPageIndex.value = index;
  }

  @override
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
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
}

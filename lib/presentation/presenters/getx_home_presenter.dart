import 'dart:convert';

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
  final RemoteLoadEnterprises remoteLoadEnterprises;

  GetxHomePresenter({
    required this.navigateTo,
    required this.remoteLoadEnterprises,
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
      final soapResponse = await remoteLoadEnterprises.get();

      if (soapResponse.responseType == SoapResponseType.error) {
        showBsErrorMessage(soapResponse.response);
      } else {
        _bsEnterprises.value = (json.decode(soapResponse.response) as List)
            .map((e) => BsEnterpriseModel.fromJson(e).toViewModel())
            .toList();

        _selectedEnterprise.value = _bsEnterprises.value?.first;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedEnterprise(BsEnterpriseViewModel? enterprise) {
    _selectedEnterprise.value = enterprise;
  }

  final _selectedEnterprise = Rx<BsEnterpriseViewModel?>(null);
  @override
  BsEnterpriseViewModel? get bsSelectedEnterprise => _selectedEnterprise.value;

  final Rx<List<BsEnterpriseViewModel>?> _bsEnterprises =
      Rx<List<BsEnterpriseViewModel>?>(null);

  @override
  List<BsEnterpriseViewModel>? get bsEnterprises => _bsEnterprises.value;

  @override
  Stream<int> get currentPageIndexStream => _currentPageIndex.stream;

  final _currentPageIndex = 0.obs;

  DateTime _selectedDate = DateTime.now();
  @override
  DateTime get selectedDate => _selectedDate;
}

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
  Stream<int> get currentPageIndexStream => _currentPageIndex.stream;

  @override
  void updateSelectedIndex(int index) {
    _currentPageIndex.value = index;
  }

  final _currentPageIndex = 0.obs;

  DateTime _selectedDate = DateTime.now();
  @override
  DateTime get selectedDate => _selectedDate;

  @override
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
  }

  @override
  void goToConfigurationsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.configurations);
  }

  final _bsEnterprises = Rx<List<BsEnterpriseViewModel>?>(null);
  @override
  Stream<List<BsEnterpriseViewModel>?> get bsEnterprisesStream =>
      _bsEnterprises.stream;

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

  final _selectedEnterprise = Rx<BsEnterpriseViewModel?>(null);
  @override
  Stream<BsEnterpriseViewModel?> get bsSelectedEnterpriseStream =>
      _selectedEnterprise.stream;

  @override
  void updateSelectedEnterprise(BsEnterpriseViewModel enterprise) {
    _selectedEnterprise.value = enterprise;
  }
}

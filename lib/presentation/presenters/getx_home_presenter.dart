import 'dart:convert';

import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
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

  final _bsEnterprises = Rx<List<BsEnterpriseEntity>?>(null);
  @override
  Stream<List<BsEnterpriseEntity>?> get bsEnterprisesStream =>
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
            .map((e) => BsEnterpriseModel.fromJson(e).toEntity())
            .toList();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}

import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter extends GetxController implements HomePresenter {
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
}

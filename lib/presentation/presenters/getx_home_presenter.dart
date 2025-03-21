import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

class GetxHomePresenter extends GetxController implements HomePresenter {
  @override
  Stream<int> get currentPageIndexStream => _currentPageIndex.stream;

  @override
  void updateSelectedIndex(int index) {
    _currentPageIndex.value = index;
  }

  final _currentPageIndex = 0.obs;
}

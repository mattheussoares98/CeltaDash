import 'package:flutter/material.dart';

import '../pages.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  DateTime get selectedDate;
  List<BsEnterpriseViewModel>? get bsEnterprises;
  BsEnterpriseViewModel? get bsSelectedEnterprise;

  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToConfigurationsPage();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
  });

  void updateSelectedEnterprise(BsEnterpriseViewModel? enterprise);
}

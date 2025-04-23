import 'package:flutter/material.dart';

import '../pages.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  DateTime get selectedDate;
  Stream<List<BsEnterpriseViewModel>?> get bsEnterprisesStream;
  Stream<BsEnterpriseViewModel?> get bsSelectedEnterpriseStream;

  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToConfigurationsPage();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
  });

  void updateSelectedEnterprise(BsEnterpriseViewModel enterprise);
}

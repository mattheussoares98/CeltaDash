import 'package:flutter/material.dart';

import '../pages.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  DateTime get selectedDate;
  List<EnterpriseViewModel>? get enterprises;
  EnterpriseViewModel? get selectedEnterprise;
  Stream<bool> get updateScreenStream;

  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToConfigurationsPage();
  void updateScreen();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
  });

  void updateSelectedEnterprise(EnterpriseViewModel? enterprise);
}

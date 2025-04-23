import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  DateTime get selectedDate;
  Stream<List<BsEnterpriseEntity>?> get bsEnterprisesStream;

  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToConfigurationsPage();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
  });
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class HomePresenter implements Listenable {
  int get currentPageIndex;
  Stream<UIError?> get mainErrorStream;
  bool get selectedEnterpriseIsEnabled;
  DateTime get selectedDate;
  List<EcEnterpriseViewModel>? get enterprises;
  EcEnterpriseViewModel? get selectedEnterprise;

  void initFirebaseStream();
  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToCanceledSalesPage();
  void goToCompareDays();
  void goToDepartmentsPage();
  void goToOperatorsPage();
  void goToPaymentsTypePage();
  void goToSellersPage();
  void goToEnterprisesManagerPage();

  Future<void> getBsEnterprises();

  void updateSelectedEnterprise(EcEnterpriseViewModel? enterprise);

  Future<void> doLogout();
  void reloadSales(
    ResumePresenter resumePresenter,
    SalesPresenter salesPresenter,
    ProductsPresenter productsPresenter, {
    required DateTime now,
    bool? forceRefresh,
  });
}

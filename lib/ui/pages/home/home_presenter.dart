import 'dart:async';

import 'package:celta_dash/ui/pages/sales/sales_presenter.dart';
import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class HomePresenter implements Listenable {
  int get currentPageIndex;
  AppMode get appMode;
  Stream<UIError?> get mainErrorStream;
  bool get selectedEnterpriseIsEnabled;
  DateTime get selectedDate;
  List<EcEnterpriseViewModel>? get enterprises;
  EcEnterpriseViewModel? get selectedEnterprise;

  void initFirebaseStream();
  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToSalesPage();
  void goToCompareDays();
  void goToCompareMonths();
  void goToDepartmentsPage();
  void goToOperatorsPage();
  void goToPaymentsTypePage();
  void goToSellersPage();
  void goToEnterprisesManagerPage();
  void goToNotSalesPage();

  Future<void> getBsEnterprises();
  Future<void> loadAppMode();
  Future<void> toggleAppMode();

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

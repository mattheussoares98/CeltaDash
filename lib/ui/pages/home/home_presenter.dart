import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  Stream<UIError?> get mainErrorStream;
  DateTime get selectedDate;
  List<EcEnterpriseViewModel>? get enterprises;
  EcEnterpriseViewModel? get selectedEnterprise;

  void initFirebaseStream();
  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToOperatorsPage();
  void goToSellersPage();
  void goToCanceledSalesPage();
  void goToProfitabilityPage();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
    required DocumentReference<Map<String, dynamic>> docRef,
  });

  void updateSelectedEnterprise(EcEnterpriseViewModel? enterprise);

  Future<void> doLogout();
  void reloadSales(
    ResumePresenter resumePresenter,
    SalesPresenter salesPresenter,
    ProductsPresenter productsPresenter, {
    bool? forceRefresh,
  });
}

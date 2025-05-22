import 'package:cloud_firestore/cloud_firestore.dart';
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
  void goToMorePage();
  void updateScreen();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
    required DocumentReference<Map<String, dynamic>> docRef,
  });

  void updateSelectedEnterprise(EnterpriseViewModel? enterprise);
  void reloadAllData(
    SalesPresenter salesPresenter,
    ResumePresenter resumePresenter,
    PaymentTypePresenter paymentTypePresenter,
    ProductsPresenter productsPresenter,
    DepartmentsPresenter departmentsPresenter, {
    bool? forceRefresh,
  });
}

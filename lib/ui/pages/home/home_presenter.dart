import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  Stream<UIError?> get mainErrorStream;
  DateTime get selectedDate;
  List<EnterpriseViewModel>? get enterprises;
  EnterpriseViewModel? get selectedEnterprise;
  Stream<bool> get updateScreenStream;

  void initFirebaseStream();
  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
  void goToOperatorsPage();
  void goToSellersPage();
  void goToProfitabilityPage();
  void updateScreen();

  Future<void> getBsEnterprises({
    required void Function(String) showBsErrorMessage,
    required DocumentReference<Map<String, dynamic>> docRef,
  });

  void updateSelectedEnterprise(EnterpriseViewModel? enterprise);

  Future<void> doLogout();
}

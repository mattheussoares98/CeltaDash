import 'package:flutter/material.dart';
import '../pages.dart';

abstract class LoginPresenter implements Listenable {
  void goToWebLoginPage();
  Future<void> login({
    required String enterpriseName,
    required String user,
    required String password,
    required EnterprisesManagerPresenter enterprisesManagerPresenter,
  });
}

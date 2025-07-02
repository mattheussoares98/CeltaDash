import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  void goToWebLoginPage();
  Future<void> login({
    required String enterpriseName,
    required String user,
    required String password,
    required EnterprisesManagerPresenter enterprisesManagerPresenter,
  });
}

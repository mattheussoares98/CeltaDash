import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class WebLoginPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> doLogin({
    required String email,
    required String password,
  });
  Future<void> doLogout();
  Future<void> goToWebCustomersIfStillLogged();
}

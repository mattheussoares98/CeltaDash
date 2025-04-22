import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  bool get changedEnterpriseName;
  void updateChangedEnterpriseName(bool value);
  Future<void> login({
    required String enterpriseName,
    required String user,
    required String password,
    required void Function(String error) showBsErrorMessage,
  });
}

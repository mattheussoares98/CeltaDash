import 'dart:async';

import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();

  LoginPresenterSpy() {
    // Mock streams
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);

    // Mock methods
    when(() => onChangedEnterpriseName()).thenReturn(null);
    when(() => login(
          enterprisesManagerPresenter:
              any(named: 'enterprisesManagerPresenter'),
          enterpriseName: any(named: 'enterpriseName'),
          user: any(named: 'user'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});
  }

  void dispose() {
    mainErrorController.close();
    isLoadingController.close();
  }

  final List<VoidCallback> _listeners = [];

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

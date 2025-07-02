import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  LoginPresenterSpy() {
    // Mock methods
    when(() => login(
          enterprisesManagerPresenter:
              any(named: 'enterprisesManagerPresenter'),
          enterpriseName: any(named: 'enterpriseName'),
          user: any(named: 'user'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});
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

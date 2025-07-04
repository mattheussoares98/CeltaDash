// ignore_for_file: unnecessary_this

import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseLoginManagementSpy extends Mock
    implements FirebaseLoginManagement {
  FirebaseLoginManagementSpy() {
    this._mockLogout();
    this._mockLogin();
    this.mockIsLoggedIn(true);
  }
  When _mockLogoutCall() => when(() => this.logout());

  void _mockLogout() {
    this._mockLogoutCall().thenAnswer((any) async => any);
  }

  void mockLogoutError() {
    this._mockLogoutCall().thenThrow(DomainError.unexpected);
  }

  When _mockLoginCall() => when(() => this.login(
        email: any(named: "email"),
        password: any(named: "password"),
      ));

  void _mockLogin() {
    this._mockLoginCall().thenAnswer((any) async => any);
  }

  void mockLoginError() {
    this._mockLoginCall().thenThrow(DomainError.unexpected);
  }

  When _mockIsLoggedInCall() => when(() => this.isLoggedIn());

  void mockIsLoggedIn(bool value) {
    this._mockIsLoggedInCall().thenAnswer((any) async => value);
  }

  void mockIsLoggedError() {
    this._mockIsLoggedInCall().thenThrow(DomainError.unexpected);
  }
}

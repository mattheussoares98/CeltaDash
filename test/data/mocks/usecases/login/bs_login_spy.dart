import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class BsLoginSpy extends Mock implements BsLogin {
  When _mockLoginCall() => when(
        () => this.login(
          user: any(named: "user"),
          password: any(named: "password"),
          url: any(named: "url"),
        ),
      );

  void mockLogin(dynamic response) {
    this._mockLoginCall().thenAnswer((any) async => response);
  }

  void mockLoginError(String error) {
    this._mockLoginCall().thenThrow(BsError(error));
  }
}

import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoginSpy extends Mock implements RemoteLogin {
  When _mockLoginCall() => when(
        () => this
            .login(user: any(named: "user"), password: any(named: "password")),
      );

  void mockLogin(SoapResponseModel response) {
    this._mockLoginCall().thenAnswer((any) async => response);
  }

  void mockLoginError() {
    this._mockLoginCall().thenThrow(DomainError.unexpected);
  }
}

import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoginSpy extends Mock implements RemoteLogin {
  When _mockLoginCall() => when(
        () => this.login(
          user: any(named: "user"),
          password: any(named: "password"),
          url: any(named: "url"),
        ),
      );

  void mockLogin(SoapResponseModel response) {
    this._mockLoginCall().thenAnswer((any) async => response);
  }

  void mockLoginError() {
    this._mockLoginCall().thenThrow(DomainError.unexpected);
  }
}

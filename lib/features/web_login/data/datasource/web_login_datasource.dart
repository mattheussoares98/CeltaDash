import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/web_login/data/datasource/datasource.dart';

class WebLoginDatasource implements IWebLoginDatasource {
  final FirebaseAuthStorage firebaseAuthStorage;

  const WebLoginDatasource(this.firebaseAuthStorage);

  @override
  Future<bool> isLoggedIn() => firebaseAuthStorage.isLoggedIn();

  @override
  Future<void> login({required String email, required String password}) =>
      firebaseAuthStorage.login(email: email, password: password);
}

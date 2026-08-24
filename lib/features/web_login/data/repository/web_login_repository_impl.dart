import 'package:celta_dash/features/web_login/data/datasource/datasource.dart';
import 'package:celta_dash/features/web_login/domain/domain.dart';

class WebLoginRepositoryImpl implements IWebLoginRepository {
  final IWebLoginDatasource datasource;

  const WebLoginRepositoryImpl(this.datasource);

  @override
  Future<bool> isLoggedIn() => datasource.isLoggedIn();

  @override
  Future<void> login({required String email, required String password}) =>
      datasource.login(email: email, password: password);
}

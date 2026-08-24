abstract class IWebLoginDatasource {
  Future<bool> isLoggedIn();

  Future<void> login({required String email, required String password});
}

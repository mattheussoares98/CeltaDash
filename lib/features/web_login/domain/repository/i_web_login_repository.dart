abstract class IWebLoginRepository {
  Future<bool> isLoggedIn();

  Future<void> login({required String email, required String password});
}

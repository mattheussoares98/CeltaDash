abstract class BsLogin {
  Future<dynamic> login({
    required String user,
    required String password,
    required String url,
  });
}

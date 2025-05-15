import 'dart:async';

abstract class FirebaseAuthStorage {
  Future<bool> isLoggedIn();
  Future<void> login({
    required String email,
    required String password,
  });
  Future<void> logout();
}

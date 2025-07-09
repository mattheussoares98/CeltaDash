import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../data/database/database.dart';
import '../../domain/helpers/helpers.dart';

class FirebaseAuthAdapter implements FirebaseAuthStorage {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthAdapter({required this.firebaseAuth});

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception();
      }
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    bool logged = false;
    final loginSubscription =
        firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        logged = true;
      }
    });
    await Future.delayed(const Duration(seconds: 3));
    loginSubscription.cancel();
    return logged;
  }
}

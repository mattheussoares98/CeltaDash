import 'package:firebase_auth/firebase_auth.dart';

import 'package:celta_dash/core/infrastructure/infrastructure.dart';

import '../../domain/helpers/helpers.dart';

class FirebaseAuthAdapter implements FirebaseAuthStorage {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthAdapter({required this.firebaseAuth});

  @override
  Future<void> login({required String email, required String password}) async {
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
  Future<bool> isLoggedIn() async => firebaseAuth.currentUser != null;
}

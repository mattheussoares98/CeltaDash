import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAdapter implements FirebaseAuthStorage {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthAdapter({required this.firebaseAuth});

  @override
  Future<void> login({required String email, required String password}) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user == null) {
      throw Exception();
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async => firebaseAuth.currentUser != null;
}

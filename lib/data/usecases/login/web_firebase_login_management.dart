import '../../../domain/usecases/usecases.dart';
import '../../../infra/databases/databases.dart';

class WebFirebaseLoginManagement implements FirebaseLoginManagement {
  final FirebaseAuthAdapter firebaseAuthAdapter;

  WebFirebaseLoginManagement({required this.firebaseAuthAdapter});

  @override
  Future<void> login({required String email, required String password}) async {
    await firebaseAuthAdapter.login(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await firebaseAuthAdapter.logout();
  }

  @override
  Future<bool> isLoggedIn() async => await firebaseAuthAdapter.isLoggedIn();
}

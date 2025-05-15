import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../databases/databases.dart';

FirebaseLoginManagement makeWebFirebaseLoginManagement() =>
    WebFirebaseLoginManagement(
      firebaseAuthAdapter: makeFirebaseAuthAdapter(),
    );

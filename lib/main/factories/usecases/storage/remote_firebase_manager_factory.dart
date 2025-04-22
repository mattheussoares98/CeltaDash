import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

FirebaseManager makeRemoteFirebaseManager() =>
    RemoteFirebaseManager(firebaseStorage: makeFirebaseAdapter());

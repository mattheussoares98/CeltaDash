import 'package:firebase_auth/firebase_auth.dart';

import '../../../infra/databases/databases.dart';

FirebaseAuthAdapter makeFirebaseAuthAdapter() => FirebaseAuthAdapter(
      firebaseAuth: FirebaseAuth.instance,
    );

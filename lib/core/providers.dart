import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/data/database/database.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/data/usecases/usecases.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/databases/databases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/infra/http/http.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'presentation/controllers/active_ec_params_state_controller.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
http.Client rawHttpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
HttpClient httpClient(Ref ref) {
  final client = ref.watch(rawHttpClientProvider);
  return HttpAdapter(client);
}

@Riverpod(keepAlive: true)
HiveStorage hiveStorage(Ref ref) {
  return HiveAdapter(box: Hive.box(DatabaseKeys.dash.name));
}

@Riverpod(keepAlive: true)
LocalStorage localStorage(Ref ref) {
  return HiveLocalStorage(
    ref.watch(hiveStorageProvider),
  ); //TODO move to the new
}

@Riverpod(keepAlive: true)
IAppStorage appStorage(Ref ref) {
  return LegacyAppStorage(ref.watch(localStorageProvider));
}

@Riverpod(keepAlive: true)
SoapRequest soapRequest(Ref ref) {
  return SoapAdapter();
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(Ref ref) {
  return FirebaseAdapter();
}

@Riverpod(keepAlive: true)
FirebaseAuthStorage firebaseAuthStorage(Ref ref) {
  return FirebaseAuthAdapter(firebaseAuth: FirebaseAuth.instance);
}

@Riverpod(keepAlive: true)
FirebaseManager firebaseManager(Ref ref) {
  return RemoteFirebaseManager(
    firebaseStorage: ref.watch(firebaseStorageProvider),
  );
}

@Riverpod(keepAlive: true)
IDeviceService deviceService(Ref ref) {
  return DeviceService();
}

import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
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
IAppStorage appStorage(Ref ref) {
  return HiveAdapter(box: Hive.box(DatabaseKeys.dash.name));
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
IDeviceService deviceService(Ref ref) {
  return DeviceService();
}

@riverpod
IThemeLocalDatasource themeLocalDatasource(Ref ref) {
  return ThemeLocalDatasource(ref.watch(appStorageProvider));
}

@riverpod
IThemeRepository themeRepository(Ref ref) {
  return ThemeRepositoryImpl(ref.watch(themeLocalDatasourceProvider));
}

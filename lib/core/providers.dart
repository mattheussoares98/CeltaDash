// lib/core/providers.dart
import 'package:celta_dash/data/database/database.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/data/usecases/usecases.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/infra/databases/databases.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/infra/http/http.dart';
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
HiveStorage hiveStorage(Ref ref) {
  return HiveAdapter(box: Hive.box(DatabaseKeys.dash.name));
}

@Riverpod(keepAlive: true)
LocalStorage localStorage(Ref ref) {
  return HiveLocalStorage(ref.watch(hiveStorageProvider));
}

@Riverpod(keepAlive: true)
SoapRequest soapRequest(Ref ref) {
  return SoapAdapter();
}

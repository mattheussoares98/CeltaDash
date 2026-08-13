// lib/core/providers.dart
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/infra/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
http.Client rawHttpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@riverpod
HttpClient httpClient(Ref ref) {
  final client = ref.watch(rawHttpClientProvider);
  return HttpAdapter(client);
}

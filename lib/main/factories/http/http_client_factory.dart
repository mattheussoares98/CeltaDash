import 'package:celta_dash/core/infrastructure/http/http.dart';
import '../../../infra/http/http.dart';

import 'package:http/http.dart';

class _HttpClientProvider {
  static final Client _client = Client();
  static Client get client => _client;
}

HttpClient makeHttpAdapter() => HttpAdapter(_HttpClientProvider.client);

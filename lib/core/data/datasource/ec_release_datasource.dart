import 'package:celta_dash/core/data/datasource/datasource.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/http/http.dart';

class EcReleaseDatasource implements IEcReleaseDatasource {
  const EcReleaseDatasource(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<String> getReleasedAtUtc(EcParams params) async {
    final response = await _httpClient.request(
      url: '${params.url}/api/Release',
      method: 'get',
      headers: params.toHeaders(),
    );

    return response as String;
  }
}

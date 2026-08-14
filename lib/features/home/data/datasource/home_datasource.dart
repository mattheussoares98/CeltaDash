import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/data/mixins/mixins.dart';
import 'package:celta_dash/features/home/data/datasource/datasource.dart';
import 'package:celta_dash/features/home/data/models/models.dart';

class HomeDatasource with ErrorHandling implements IHomeDatasource {
  const HomeDatasource(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<List<BSFEnterpriseModel>> getEnterprises(EcParams ecParams) async {
    try {
      final response = await _httpClient.request(
        url: '${ecParams.url}/api/enterprises',
        method: 'get',
        headers: ecParams.toHeaders(),
      );

      return (response as List)
          .map((item) => BSFEnterpriseModel.fromJson(item as Map))
          .toList();
    } catch (error) {
      treatError(error);
    }
  }
}

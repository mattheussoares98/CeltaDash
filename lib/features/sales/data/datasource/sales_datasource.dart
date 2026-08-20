import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/features/sales/data/datasource/datasource.dart';
import 'package:celta_dash/features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';

class SalesDatasource implements ISalesDatasource {
  const SalesDatasource(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<SaleMovementModel> getSaleMovements({
    required GetSaleMovementParams params,
    required EcParams ecParams,
  }) async {
    final response = await _httpClient.request(
      url: '${ecParams.url}/api/salemovements',
      method: 'post',
      headers: ecParams.toHeaders(),
      body: params.toBody(),
    );

    return SaleMovementModel.fromJson(response as Map);
  }
}

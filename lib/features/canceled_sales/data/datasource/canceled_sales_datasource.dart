import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/features/canceled_sales/data/datasource/datasource.dart';
import 'package:celta_dash/features/canceled_sales/data/models/models.dart';
import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';

class CanceledSalesDatasource implements ICanceledSalesDatasource {
  const CanceledSalesDatasource(this._httpClient);

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

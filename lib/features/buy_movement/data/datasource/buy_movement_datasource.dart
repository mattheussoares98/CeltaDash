import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:celta_dash/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_dash/features/buy_movement/data/models/models.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';

class BuyMovementDatasource implements IBuyMovementDatasource {
  final HttpClient _httpClient;

  const BuyMovementDatasource(this._httpClient);

  @override
  Future<BuyMovementDataResponseModel> getData({
    required SearchBuyMovementDataParamsEntity params,
    required EcParams ecParams,
  }) async {
    final response = await _httpClient.request(
      url: '${ecParams.url}/api/BuyMovements/GetData',
      method: 'post',
      headers: ecParams.toHeaders(),
      body: SearchBuyMovementDataModel.fromEntity(params).toJson(),
    );

    return BuyMovementDataResponseModel.fromJson(response as Map? ?? {});
  }
}

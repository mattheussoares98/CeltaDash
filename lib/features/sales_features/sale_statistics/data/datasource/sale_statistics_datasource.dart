// lib/features/sale_statistics/data/datasource/sale_statistics_datasource.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/data/datasource/i_sale_statistics_datasource.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/data/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';

class SaleStatisticsDatasource implements ISaleStatisticsDatasource {
  final HttpClient _httpClient;

  const SaleStatisticsDatasource(this._httpClient);

  @override
  Future<List<SaleStatisticsModel>> getSaleStatistics({
    required GetSaleStatisticsParams params,
    required EcParams ecParams,
  }) async {
    final response = await _httpClient.request(
      url: "${ecParams.url}/api/salemovements/getstatistics",
      method: "post",
      headers: ecParams.toHeaders(),
      body: params.toBody(),
    );

    final List<dynamic> results = (response['results'] as List?) ?? [];
    return results.map((e) => SaleStatisticsModel.fromJson(e as Map)).toList();
  }
}

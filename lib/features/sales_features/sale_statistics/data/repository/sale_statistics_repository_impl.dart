// lib/features/sale_statistics/data/repository/sale_statistics_repository_impl.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/data/datasource/datasource.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/repository/repository.dart';

class SaleStatisticsRepositoryImpl implements ISaleStatisticsRepository {
  final ISaleStatisticsDatasource _datasource;

  const SaleStatisticsRepositoryImpl(this._datasource);

  @override
  Future<List<SaleStatisticsEntity>> getSaleStatistics({
    required GetSaleStatisticsParams params,
    required EcParams ecParams,
  }) async {
    final models = await _datasource.getSaleStatistics(
      params: params,
      ecParams: ecParams,
    );

    return models.map((model) => model.toEntity()).toList();
  }
}

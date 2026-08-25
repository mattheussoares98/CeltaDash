// lib/features/sale_statistics/domain/repository/i_sale_statistics_repository.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';

abstract class ISaleStatisticsRepository {
  Future<List<SaleStatisticsEntity>> getSaleStatistics({
    required GetSaleStatisticsParams params,
    required EcParams ecParams,
  });
}

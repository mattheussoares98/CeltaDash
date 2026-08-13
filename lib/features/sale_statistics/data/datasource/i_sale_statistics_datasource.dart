// lib/features/sale_statistics/data/datasource/i_sale_statistics_datasource.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sale_statistics/data/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';

abstract class ISaleStatisticsDatasource {
  Future<List<SaleStatisticsModel>> getSaleStatistics({
    required GetSaleStatisticsParams params,
    required EcParams ecParams,
  });
}

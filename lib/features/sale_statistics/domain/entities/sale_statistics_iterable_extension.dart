import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';

extension SaleStatisticsIterableExtension on Iterable<SaleStatisticsEntity> {
  num sumLiquidValue() =>
      fold(0, (total, statistic) => total + (statistic.LiquidValue ?? 0));

  int sumCustomers() =>
      fold(0, (total, statistic) => total + (statistic.QuantitySales ?? 0));
}

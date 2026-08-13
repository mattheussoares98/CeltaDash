import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/sale_statistics/data/data.dart';
import 'package:celta_dash/features/sale_statistics/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
ISaleStatisticsDatasource saleStatisticsDatasource(Ref ref) {
  return SaleStatisticsDatasource(ref.watch(httpClientProvider));
}

@riverpod
ISaleStatisticsRepository saleStatisticsRepository(Ref ref) {
  return SaleStatisticsRepositoryImpl(
    ref.watch(saleStatisticsDatasourceProvider),
  );
}

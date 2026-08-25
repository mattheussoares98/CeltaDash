import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/sales_features/sales/data/data.dart';
import 'package:celta_dash/features/sales_features/sales/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
ISalesDatasource salesDatasource(Ref ref) {
  return SalesDatasource(ref.watch(httpClientProvider));
}

@riverpod
ISalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(ref.watch(salesDatasourceProvider));
}

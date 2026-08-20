import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/canceled_sales/data/data.dart';
import 'package:celta_dash/features/canceled_sales/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
ICanceledSalesDatasource canceledSalesDatasource(Ref ref) {
  return CanceledSalesDatasource(ref.watch(httpClientProvider));
}

@riverpod
ICanceledSalesRepository canceledSalesRepository(Ref ref) {
  return CanceledSalesRepositoryImpl(
    ref.watch(canceledSalesDatasourceProvider),
  );
}

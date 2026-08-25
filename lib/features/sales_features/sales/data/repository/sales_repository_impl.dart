import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sales_features/sales/data/datasource/datasource.dart';
import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sales/domain/repository/repository.dart';

class SalesRepositoryImpl implements ISalesRepository {
  const SalesRepositoryImpl(this._datasource);

  final ISalesDatasource _datasource;

  @override
  Future<SaleMovementEntity> getSaleMovements({
    required GetSaleMovementParams params,
    required EcParams ecParams,
  }) async {
    final model = await _datasource.getSaleMovements(
      params: params,
      ecParams: ecParams,
    );
    return model.toEntity();
  }
}

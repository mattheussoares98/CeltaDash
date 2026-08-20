import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/canceled_sales/data/datasource/datasource.dart';
import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';
import 'package:celta_dash/features/canceled_sales/domain/repository/repository.dart';

class CanceledSalesRepositoryImpl implements ICanceledSalesRepository {
  const CanceledSalesRepositoryImpl(this._datasource);

  final ICanceledSalesDatasource _datasource;

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

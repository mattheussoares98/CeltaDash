import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';

abstract class ISalesRepository {
  Future<SaleMovementEntity> getSaleMovements({
    required GetSaleMovementParams params,
    required EcParams ecParams,
  });
}

import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';

abstract class ISalesDatasource {
  Future<SaleMovementModel> getSaleMovements({
    required GetSaleMovementParams params,
    required EcParams ecParams,
  });
}

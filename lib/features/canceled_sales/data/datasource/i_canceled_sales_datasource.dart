import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/canceled_sales/data/models/models.dart';
import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';

abstract class ICanceledSalesDatasource {
  Future<SaleMovementModel> getSaleMovements({
    required GetSaleMovementParams params,
    required EcParams ecParams,
  });
}

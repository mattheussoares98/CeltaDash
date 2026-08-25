import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';

import '../../entities/entities.dart';

export 'package:celta_dash/features/sales_features/sales/domain/entities/get_sale_movement_params.dart';

abstract class LoadSaleMovements {
  Future<SaleMovementEntity> get(GetSaleMovementParams params);
}

import '../../entities/entities.dart';
import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';

export 'package:celta_dash/features/canceled_sales/domain/entities/get_sale_movement_params.dart';

abstract class LoadSaleMovements {
  Future<SaleMovementEntity> get(GetSaleMovementParams params);
}

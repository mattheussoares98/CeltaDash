import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';

abstract class IBuyMovementRepository {
  Future<BuyMovementDataResponseEntity> getData({
    required SearchBuyMovementDataParamsEntity params,
    required EcParams ecParams,
  });
}

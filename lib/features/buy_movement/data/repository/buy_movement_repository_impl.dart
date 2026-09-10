import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/domain/repository/repository.dart';

class BuyMovementRepositoryImpl implements IBuyMovementRepository {
  final IBuyMovementDatasource _datasource;

  const BuyMovementRepositoryImpl(this._datasource);

  @override
  Future<BuyMovementDataResponseEntity> getData({
    required SearchBuyMovementDataParamsEntity params,
    required EcParams ecParams,
  }) async {
    final model = await _datasource.getData(params: params, ecParams: ecParams);

    final entity = model.toEntity();

    return BuyMovementDataResponseEntity(
      searchParameters: params,
      results: entity.results,
    );
  }
}

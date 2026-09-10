import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataResponseEntity extends Equatable {
  final SearchBuyMovementDataParamsEntity? searchParameters;
  final List<BuyMovementDataRowEntity> results;

  const BuyMovementDataResponseEntity({
    this.searchParameters,
    this.results = const [],
  });

  @override
  List<Object?> get props => [searchParameters, results];
}

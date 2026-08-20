import 'package:equatable/equatable.dart';

import 'package:celta_dash/features/canceled_sales/domain/entities/entities.dart';

class SaleMovementFinalizationEntity extends Equatable {
  final int? Id;
  final double? Value;
  final int? QuantityOfPortions;
  final DateTime? DateOfExpiration;
  final SaleMovementFinalizationFinalizationEntity? Finalization;

  const SaleMovementFinalizationEntity({
    required this.Id,
    required this.Value,
    required this.QuantityOfPortions,
    required this.DateOfExpiration,
    required this.Finalization,
  });

  @override
  List<Object?> get props => [
    Id,
    Value,
    QuantityOfPortions,
    DateOfExpiration,
    Finalization,
  ];
}

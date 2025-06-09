import 'package:equatable/equatable.dart';

import 'view_model.dart';

class SaleMovementFinalizationViewModel extends Equatable {
  final String? Id;
  final String? Value;
  final String? QuantityOfPortions;
  final String? DateOfExpiration;
  final SaleMovementFinalizationFinalizationViewModel? Finalization;

  const SaleMovementFinalizationViewModel({
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

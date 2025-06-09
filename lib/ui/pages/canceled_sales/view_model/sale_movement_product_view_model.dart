import 'package:equatable/equatable.dart';

import 'view_model.dart';

class SaleMovementProductViewModel extends Equatable {
  final String? Id;
  final String? Quantity;
  final String? UnitValue;
  final String? IsCancelled;
  final String? UnitValueLiquid;
  final String? RepositionCost;
  final String? LiquidCost;
  final String? TotalBrute;
  final String? TotalLiquid;
  final String? TotalDiscounts;
  final String? ProductPackingId;
  final SaleMovementProductProductViewModel? Product;

  const SaleMovementProductViewModel({
    required this.Id,
    required this.Quantity,
    required this.UnitValue,
    required this.IsCancelled,
    required this.UnitValueLiquid,
    required this.RepositionCost,
    required this.LiquidCost,
    required this.TotalBrute,
    required this.TotalLiquid,
    required this.TotalDiscounts,
    required this.ProductPackingId,
    required this.Product,
  });

  @override
  List<Object?> get props => [
        Id,
        Quantity,
        UnitValue,
        IsCancelled,
        UnitValueLiquid,
        RepositionCost,
        LiquidCost,
        TotalBrute,
        TotalLiquid,
        TotalDiscounts,
        ProductPackingId,
        Product,
      ];
}

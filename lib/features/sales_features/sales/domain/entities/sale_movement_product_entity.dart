import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SaleMovementProductEntity extends Equatable {
  final int? Id;
  final double? Quantity;
  final double? UnitValue;
  final bool? IsCancelled;
  final double? UnitValueLiquid;
  final double? RepositionCost;
  final double? LiquidCost;
  final double? TotalBrute;
  final double? TotalLiquid;
  final double? TotalDiscounts;
  final int? ProductPackingId;
  final SaleMovementProductProductEntity? Product;

  const SaleMovementProductEntity({
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

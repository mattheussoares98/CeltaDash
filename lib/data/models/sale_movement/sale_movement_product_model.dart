import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'sale_movement_product_product_model.dart';

class SaleMovementProductModel extends Equatable {
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
  final SaleMovementProductProductModel? Product;

  const SaleMovementProductModel({
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

  factory SaleMovementProductModel.fromJson(Map json) =>
      SaleMovementProductModel(
        Id: json['Id'],
        Quantity: (json['Quantity'] as num?)?.toDouble(),
        UnitValue: (json['UnitValue'] as num?)?.toDouble(),
        IsCancelled: json['IsCancelled'] as bool?,
        UnitValueLiquid: (json['UnitValueLiquid'] as num?)?.toDouble(),
        RepositionCost: (json['RepositionCost'] as num?)?.toDouble(),
        LiquidCost: (json['LiquidCost'] as num?)?.toDouble(),
        TotalBrute: (json['TotalBrute'] as num?)?.toDouble(),
        TotalLiquid: (json['TotalLiquid'] as num?)?.toDouble(),
        TotalDiscounts: (json['TotalDiscounts'] as num?)?.toDouble(),
        ProductPackingId: json['ProductPackingId'],
        Product: json['Product'] != null
            ? SaleMovementProductProductModel.fromJson(
                json['Product'] as Map)
            : null,
      );

  factory SaleMovementProductModel.fromEntity(
          SaleMovementProductEntity? entity) =>
      SaleMovementProductModel(
        Id: entity?.Id,
        Quantity: entity?.Quantity,
        UnitValue: entity?.UnitValue,
        IsCancelled: entity?.IsCancelled,
        UnitValueLiquid: entity?.UnitValueLiquid,
        RepositionCost: entity?.RepositionCost,
        LiquidCost: entity?.LiquidCost,
        TotalBrute: entity?.TotalBrute,
        TotalLiquid: entity?.TotalLiquid,
        TotalDiscounts: entity?.TotalDiscounts,
        ProductPackingId: entity?.ProductPackingId,
        Product: entity?.Product != null
            ? SaleMovementProductProductModel.fromEntity(entity!.Product)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'Quantity': Quantity,
        'UnitValue': UnitValue,
        'IsCancelled': IsCancelled,
        'UnitValueLiquid': UnitValueLiquid,
        'RepositionCost': RepositionCost,
        'LiquidCost': LiquidCost,
        'TotalBrute': TotalBrute,
        'TotalLiquid': TotalLiquid,
        'TotalDiscounts': TotalDiscounts,
        'ProductPackingId': ProductPackingId,
        'Product': Product?.toJson(),
      };

  SaleMovementProductEntity toEntity() => SaleMovementProductEntity(
        Id: Id,
        Quantity: Quantity,
        UnitValue: UnitValue,
        IsCancelled: IsCancelled,
        UnitValueLiquid: UnitValueLiquid,
        RepositionCost: RepositionCost,
        LiquidCost: LiquidCost,
        TotalBrute: TotalBrute,
        TotalLiquid: TotalLiquid,
        TotalDiscounts: TotalDiscounts,
        ProductPackingId: ProductPackingId,
        Product: Product?.toEntity(),
      );
}

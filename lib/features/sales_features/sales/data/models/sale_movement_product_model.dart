import 'package:celta_dash/features/sales_features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

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
        Id: json['id'],
        Quantity: (json['quantity'] as num?)?.toDouble(),
        UnitValue: (json['unitValue'] as num?)?.toDouble(),
        IsCancelled: json['isCancelled'] as bool?,
        UnitValueLiquid: (json['unitValueLiquid'] as num?)?.toDouble(),
        RepositionCost: (json['repositionCost'] as num?)?.toDouble(),
        LiquidCost: (json['liquidCost'] as num?)?.toDouble(),
        TotalBrute: (json['totalBrute'] as num?)?.toDouble(),
        TotalLiquid: (json['totalLiquid'] as num?)?.toDouble(),
        TotalDiscounts: (json['totalDiscounts'] as num?)?.toDouble(),
        ProductPackingId: json['productPackingId'],
        Product: json['product'] != null
            ? SaleMovementProductProductModel.fromJson(json['product'] as Map)
            : null,
      );

  factory SaleMovementProductModel.fromEntity(
    SaleMovementProductEntity? entity,
  ) => SaleMovementProductModel(
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
    'id': Id,
    'quantity': Quantity,
    'unitValue': UnitValue,
    'isCancelled': IsCancelled,
    'unitValueLiquid': UnitValueLiquid,
    'repositionCost': RepositionCost,
    'liquidCost': LiquidCost,
    'totalBrute': TotalBrute,
    'totalLiquid': TotalLiquid,
    'totalDiscounts': TotalDiscounts,
    'productPackingId': ProductPackingId,
    'product': Product?.toJson(),
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

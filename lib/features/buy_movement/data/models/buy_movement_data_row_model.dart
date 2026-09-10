import 'package:celta_dash/features/buy_movement/data/models/models.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataRowModel extends Equatable {
  final DateTime? date;
  final BuyMovementDataProductModel? product;
  final BuyMovementDataSupplierModel? supplier;
  final num totalValue;

  const BuyMovementDataRowModel({
    this.date,
    this.product,
    this.supplier,
    required this.totalValue,
  });

  factory BuyMovementDataRowModel.fromJson(Map json) {
    final product = (json['Product'] ?? json['product']) as Map?;
    final supplier = (json['Supplier'] ?? json['supplier']) as Map?;

    return BuyMovementDataRowModel(
      date: DateTime.tryParse((json['Date'] ?? json['date'])?.toString() ?? ''),
      product: product == null
          ? null
          : BuyMovementDataProductModel.fromJson(product),
      supplier: supplier == null
          ? null
          : BuyMovementDataSupplierModel.fromJson(supplier),
      totalValue: (json['TotalValue'] ?? json['totalValue']) as num? ?? 0,
    );
  }

  factory BuyMovementDataRowModel.fromEntity(BuyMovementDataRowEntity entity) =>
      BuyMovementDataRowModel(
        date: entity.date,
        product: entity.product == null
            ? null
            : BuyMovementDataProductModel.fromEntity(entity.product!),
        supplier: entity.supplier == null
            ? null
            : BuyMovementDataSupplierModel.fromEntity(entity.supplier!),
        totalValue: entity.totalValue,
      );

  BuyMovementDataRowEntity toEntity() => BuyMovementDataRowEntity(
    date: date,
    product: product?.toEntity(),
    supplier: supplier?.toEntity(),
    totalValue: totalValue,
  );

  Map toJson() => {
    'Date': date?.toIso8601String(),
    'Product': product?.toJson(),
    'Supplier': supplier?.toJson(),
    'TotalValue': totalValue,
  };

  @override
  List<Object?> get props => [date, product, supplier, totalValue];
}

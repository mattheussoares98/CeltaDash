import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SaleMovementModel extends Equatable {
  final String? Enterprise;
  final double? LiquidValue;
  final int? Year;
  final int? Month;
  final DateTime? Date;
  final int? Hour;
  final String? Product;

  const SaleMovementModel({
    required this.Enterprise,
    required this.LiquidValue,
    required this.Year,
    required this.Month,
    required this.Date,
    required this.Hour,
    required this.Product,
  });

  @override
  List<Object?> get props => [
    Enterprise,
    LiquidValue,
    Year,
    Month,
    Date,
    Hour,
    Product,
  ];

  factory SaleMovementModel.fromJson(Map json) => SaleMovementModel(
    Enterprise: json['Enterprise'],
    LiquidValue: json['LiquidValue'],
    Year: json['Year'],
    Month: json['Month'],
    Date: DateTime.parse(json['Date']),
    Hour: json['Hour'],
    Product: json['Product'],
  );

  factory SaleMovementModel.fromEntity(SaleMovementEntity entity) =>
      SaleMovementModel(
        Enterprise: entity.Enterprise,
        LiquidValue: entity.LiquidValue,
        Year: entity.Year,
        Month: entity.Month,
        Date: entity.Date,
        Hour: entity.Hour,
        Product: entity.Product,
      );

  Map<String, dynamic> toJson() => {
    'Enterprise': Enterprise,
    'LiquidValue': LiquidValue,
    'Year': Year,
    'Month': Month,
    'Date': Date?.toIso8601String(),
    'Hour': Hour,
    'Product': Product,
  };

  SaleMovementEntity toEntity() => SaleMovementEntity(
    Enterprise: Enterprise,
    LiquidValue: LiquidValue,
    Year: Year,
    Month: Month,
    Date: Date,
    Hour: Hour,
    Product: Product,
  );
}

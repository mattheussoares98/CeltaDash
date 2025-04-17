import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SaleMovementModel extends Equatable {
  final String? Enterprise;
  final double? LiquidValue;
  final String? Year;
  final String? Month;
  final String? Date;
  final String? Hour;
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
    Date: json['Date'],
    Hour: json['Hour'],
    Product: json['Product'],
  );

  Map<String, dynamic> toJson() => {
    'Enterprise': Enterprise,
    'LiquidValue': LiquidValue,
    'Year': Year,
    'Month': Month,
    'Date': Date,
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

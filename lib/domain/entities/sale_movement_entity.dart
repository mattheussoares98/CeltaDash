import 'package:equatable/equatable.dart';

class SaleMovementEntity extends Equatable {
  final String? Enterprise;
  final double? LiquidValue;
  final String? Year;
  final String? Month;
  final String? Date;
  final String? Hour;
  final String? Product;

  const SaleMovementEntity({
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
}

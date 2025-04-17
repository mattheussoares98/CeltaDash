import 'package:equatable/equatable.dart';

class SaleMovementEntity extends Equatable {
  final DateTime? Date;
  final double? LiquidValue;
  final int? Year;
  final int? Month;
  final int? Hour;
  final String? Enterprise;
  final String? Product;

  const SaleMovementEntity({
    required this.Date,
    required this.LiquidValue,
    required this.Year,
    required this.Month,
    required this.Hour,
    required this.Enterprise,
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

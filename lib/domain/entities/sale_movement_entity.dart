import 'package:equatable/equatable.dart';

class SaleMovementEntity extends Equatable {
  final DateTime? Date;
  final double? LiquidValue;
  final int? Year;
  final int? Month;
  final int? Hour;
  final int? QuantitySales;
  final String? Product;
  final String? ProductDepartment;
  final String? ProductSection;
  final String? PaymentFinalization;
  final String? PaymentModality;
  final int? EnterpriseId;
  final String? EnterprisePersonalizedCode;
  final String? EnterpriseFantasyName;

  const SaleMovementEntity({
    required this.Date,
    required this.LiquidValue,
    required this.Year,
    required this.Month,
    required this.Hour,
    required this.QuantitySales,
    required this.Product,
    required this.ProductDepartment,
    required this.ProductSection,
    required this.PaymentFinalization,
    required this.PaymentModality,
    required this.EnterpriseId,
    required this.EnterprisePersonalizedCode,
    required this.EnterpriseFantasyName,
  });

  @override
  List<Object?> get props => [
        LiquidValue,
        Year,
        Month,
        Date,
        Hour,
        QuantitySales,
        Product,
        ProductDepartment,
        ProductSection,
        PaymentFinalization,
        PaymentModality,
        EnterpriseId,
        EnterprisePersonalizedCode,
        EnterpriseFantasyName,
      ];
}

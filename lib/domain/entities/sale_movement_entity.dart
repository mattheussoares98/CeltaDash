import 'package:equatable/equatable.dart';

class SaleMovementEntity extends Equatable {
  final DateTime? Date;
  final num? LiquidValue;
  final num? QuantityOfProducts;
  final num? TotalRepositionCost;
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
  final String? CashierOperator;
  final String? Seller;

  const SaleMovementEntity({
    required this.Date,
    required this.LiquidValue,
    required this.QuantityOfProducts,
    required this.TotalRepositionCost,
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
    required this.CashierOperator,
    required this.Seller,
  });

  @override
  List<Object?> get props => [
        LiquidValue,
        QuantityOfProducts,
        TotalRepositionCost,
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
        CashierOperator,
        Seller,
      ];
}

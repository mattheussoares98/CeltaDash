import 'package:equatable/equatable.dart';

class SaleMovementViewModel extends Equatable {
  final DateTime? Date;
  final String? LiquidValue;
  final String? Year;
  final String? Month;
  final String? Hour;
  final String? Product;
  final String? ProductDepartment;
  final String? ProductSection;
  final String? PaymentFinalization;
  final String? PaymentModality;
  final String? EnterpriseId;
  final String? EnterprisePersonalizedCode;
  final String? EnterpriseFantasyName;
  final String? QuantitySales;
  final String? CashierOperator;
  final String? Seller;
  final String? TotalRepositionCost;
  final String? QuantityOfProducts;

  const SaleMovementViewModel({
    required this.Date,
    required this.LiquidValue,
    required this.Year,
    required this.Month,
    required this.Hour,
    required this.Product,
    required this.ProductDepartment,
    required this.ProductSection,
    required this.PaymentFinalization,
    required this.PaymentModality,
    required this.EnterpriseId,
    required this.EnterprisePersonalizedCode,
    required this.EnterpriseFantasyName,
    required this.QuantitySales,
    required this.CashierOperator,
    required this.Seller,
    required this.TotalRepositionCost,
    required this.QuantityOfProducts,
  });

  @override
  List<Object?> get props => [
        LiquidValue,
        Year,
        Month,
        Date,
        Hour,
        Product,
        ProductDepartment,
        ProductSection,
        PaymentFinalization,
        PaymentModality,
        EnterpriseId,
        EnterprisePersonalizedCode,
        EnterpriseFantasyName,
        QuantitySales,
        CashierOperator,
        Seller,
        TotalRepositionCost,
        QuantityOfProducts,
      ];
}

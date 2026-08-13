// lib/features/sale_statistics/domain/entities/sale_statistics_entity.dart
import 'package:equatable/equatable.dart';

class SaleStatisticsEntity extends Equatable {
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

  const SaleStatisticsEntity({
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

  SaleStatisticsEntity copyWith({
    DateTime? Date,
    num? LiquidValue,
    num? QuantityOfProducts,
    num? TotalRepositionCost,
    int? Year,
    int? Month,
    int? Hour,
    int? QuantitySales,
    String? Product,
    String? ProductDepartment,
    String? ProductSection,
    String? PaymentFinalization,
    String? PaymentModality,
    int? EnterpriseId,
    String? EnterprisePersonalizedCode,
    String? EnterpriseFantasyName,
    String? CashierOperator,
    String? Seller,
  }) {
    return SaleStatisticsEntity(
      Date: Date ?? this.Date,
      LiquidValue: LiquidValue ?? this.LiquidValue,
      QuantityOfProducts: QuantityOfProducts ?? this.QuantityOfProducts,
      TotalRepositionCost: TotalRepositionCost ?? this.TotalRepositionCost,
      Year: Year ?? this.Year,
      Month: Month ?? this.Month,
      Hour: Hour ?? this.Hour,
      QuantitySales: QuantitySales ?? this.QuantitySales,
      Product: Product ?? this.Product,
      ProductDepartment: ProductDepartment ?? this.ProductDepartment,
      ProductSection: ProductSection ?? this.ProductSection,
      PaymentFinalization: PaymentFinalization ?? this.PaymentFinalization,
      PaymentModality: PaymentModality ?? this.PaymentModality,
      EnterpriseId: EnterpriseId ?? this.EnterpriseId,
      EnterprisePersonalizedCode:
          EnterprisePersonalizedCode ?? this.EnterprisePersonalizedCode,
      EnterpriseFantasyName:
          EnterpriseFantasyName ?? this.EnterpriseFantasyName,
      CashierOperator: CashierOperator ?? this.CashierOperator,
      Seller: Seller ?? this.Seller,
    );
  }

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

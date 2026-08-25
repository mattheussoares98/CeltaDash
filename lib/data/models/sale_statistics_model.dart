import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SaleStatisticsModel extends Equatable {
  final num? LiquidValue;
  final num? QuantityOfProducts;
  final num? TotalRepositionCost;
  final int? Year;
  final int? Month;
  final DateTime? Date;
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

  const SaleStatisticsModel({
    required this.LiquidValue,
    required this.QuantityOfProducts,
    required this.TotalRepositionCost,
    required this.Year,
    required this.Month,
    required this.Date,
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
    QuantitySales,
  ];

  factory SaleStatisticsModel.fromJson(Map json) => SaleStatisticsModel(
    LiquidValue: json['LiquidValue'],
    QuantityOfProducts: json['QuantityOfProducts'],
    TotalRepositionCost: json['TotalRepositionCost'],
    Year: json['Year'],
    Month: json['Month'],
    Date: json['Date'] == null ? null : DateTime.parse(json['Date']),
    Hour: json['Hour'],
    Product: json['Product'],
    ProductDepartment: json['ProductDepartment'],
    ProductSection: json['ProductSection'],
    PaymentFinalization: json['PaymentFinalization'],
    PaymentModality: json['PaymentModality'],
    EnterpriseId: json['EnterpriseId'],
    EnterprisePersonalizedCode: json['EnterprisePersonalizedCode'],
    EnterpriseFantasyName: json['EnterpriseFantasyName'],
    CashierOperator: json['CashierOperator'],
    Seller: json['Seller'],
    QuantitySales: json['QuantitySales'],
  );

  factory SaleStatisticsModel.fromEntity(SaleStatisticsEntity entity) =>
      SaleStatisticsModel(
        LiquidValue: entity.LiquidValue,
        QuantityOfProducts: entity.QuantityOfProducts,
        TotalRepositionCost: entity.TotalRepositionCost,
        Year: entity.Year,
        Month: entity.Month,
        Date: entity.Date,
        Hour: entity.Hour,
        Product: entity.Product,
        ProductDepartment: entity.ProductDepartment,
        ProductSection: entity.ProductSection,
        PaymentFinalization: entity.PaymentFinalization,
        PaymentModality: entity.PaymentModality,
        EnterpriseId: entity.EnterpriseId,
        EnterprisePersonalizedCode: entity.EnterprisePersonalizedCode,
        EnterpriseFantasyName: entity.EnterpriseFantasyName,
        CashierOperator: entity.CashierOperator,
        Seller: entity.Seller,
        QuantitySales: entity.QuantitySales,
      );

  Map<String, dynamic> toJson() => {
    'LiquidValue': LiquidValue,
    'QuantityOfProducts': QuantityOfProducts,
    'TotalRepositionCost': TotalRepositionCost,
    'Year': Year,
    'Month': Month,
    'Date': Date?.toIso8601String(),
    'Hour': Hour,
    'Product': Product,
    'ProductDepartment': ProductDepartment,
    'ProductSection': ProductSection,
    'PaymentFinalization': PaymentFinalization,
    'PaymentModality': PaymentModality,
    'EnterpriseId': EnterpriseId,
    'EnterprisePersonalizedCode': EnterprisePersonalizedCode,
    'EnterpriseFantasyName': EnterpriseFantasyName,
    'CashierOperator': CashierOperator,
    'Seller': Seller,
    'QuantitySales': QuantitySales,
  };

  SaleStatisticsEntity toEntity() => SaleStatisticsEntity(
    LiquidValue: LiquidValue,
    QuantityOfProducts: QuantityOfProducts,
    TotalRepositionCost: TotalRepositionCost,
    Year: Year,
    Month: Month,
    Date: Date,
    Hour: Hour,
    Product: Product,
    ProductDepartment: ProductDepartment,
    ProductSection: ProductSection,
    PaymentFinalization: PaymentFinalization,
    PaymentModality: PaymentModality,
    EnterpriseId: EnterpriseId,
    EnterprisePersonalizedCode: EnterprisePersonalizedCode,
    EnterpriseFantasyName: EnterpriseFantasyName,
    CashierOperator: CashierOperator,
    Seller: Seller,
    QuantitySales: QuantitySales,
  );

}

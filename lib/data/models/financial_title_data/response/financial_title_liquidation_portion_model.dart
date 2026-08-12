import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleLiquidationPortionModel
    extends FinancialTitleLiquidationPortionEntity {
  const FinancialTitleLiquidationPortionModel({
    required super.financialTitleLiquidationPortionCode,
    required super.financialTitlePortionCode,
    required super.value,
    required super.expenseAccessory,
    required super.expenseRegistry,
    required super.interest,
    required super.increment,
    required super.discount,
    required super.fine,
    required super.collectTax,
    required super.discountByAnticipatedPay,
    required super.liquidationDate,
  });

  factory FinancialTitleLiquidationPortionModel.fromJson(Map json) =>
      FinancialTitleLiquidationPortionModel(
        financialTitleLiquidationPortionCode:
            json['financialTitleLiquidationPortionCode'] as int?,
        financialTitlePortionCode: json['financialTitlePortionCode'] as int?,
        value: json['value'] as num?,
        expenseAccessory: json['expenseAccessory'] as num?,
        expenseRegistry: json['expenseRegistry'] as num?,
        interest: json['interest'] as num?,
        increment: json['increment'] as num?,
        discount: json['discount'] as num?,
        fine: json['fine'] as num?,
        collectTax: json['collectTax'] as num?,
        discountByAnticipatedPay: json['discountByAnticipatedPay'] as num?,
        liquidationDate: json['liquidationDate'] == null
            ? null
            : DateTime.parse(json['liquidationDate'] as String),
      );

  factory FinancialTitleLiquidationPortionModel.fromEntity(
          FinancialTitleLiquidationPortionEntity entity) =>
      FinancialTitleLiquidationPortionModel(
        financialTitleLiquidationPortionCode:
            entity.financialTitleLiquidationPortionCode,
        financialTitlePortionCode: entity.financialTitlePortionCode,
        value: entity.value,
        expenseAccessory: entity.expenseAccessory,
        expenseRegistry: entity.expenseRegistry,
        interest: entity.interest,
        increment: entity.increment,
        discount: entity.discount,
        fine: entity.fine,
        collectTax: entity.collectTax,
        discountByAnticipatedPay: entity.discountByAnticipatedPay,
        liquidationDate: entity.liquidationDate,
      );

  Map<String, dynamic> toJson() => {
        'financialTitleLiquidationPortionCode':
            financialTitleLiquidationPortionCode,
        'financialTitlePortionCode': financialTitlePortionCode,
        'value': value,
        'expenseAccessory': expenseAccessory,
        'expenseRegistry': expenseRegistry,
        'interest': interest,
        'increment': increment,
        'discount': discount,
        'fine': fine,
        'collectTax': collectTax,
        'discountByAnticipatedPay': discountByAnticipatedPay,
        'liquidationDate': liquidationDate?.toIso8601String(),
      };

  FinancialTitleLiquidationPortionEntity toEntity() =>
      FinancialTitleLiquidationPortionEntity(
        financialTitleLiquidationPortionCode:
            financialTitleLiquidationPortionCode,
        financialTitlePortionCode: financialTitlePortionCode,
        value: value,
        expenseAccessory: expenseAccessory,
        expenseRegistry: expenseRegistry,
        interest: interest,
        increment: increment,
        discount: discount,
        fine: fine,
        collectTax: collectTax,
        discountByAnticipatedPay: discountByAnticipatedPay,
        liquidationDate: liquidationDate,
      );
}

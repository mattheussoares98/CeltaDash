import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleLiquidationPaymentFormModel
    extends FinancialTitleLiquidationPaymentFormEntity {
  const FinancialTitleLiquidationPaymentFormModel({
    required super.financialTitleLiquidationPortionPaymentFormCode,
    required super.financialTitleLiquidationPortionCode,
    required super.financialTitlePortionCode,
    required super.paymentFormDescription,
    required super.value,
    required super.expenseAccessory,
    required super.expenseRegistry,
    required super.interest,
    required super.increment,
    required super.discount,
    required super.fine,
    required super.discountByAnticipatedPay,
    required super.collectTax,
  });

  factory FinancialTitleLiquidationPaymentFormModel.fromJson(Map json) =>
      FinancialTitleLiquidationPaymentFormModel(
        financialTitleLiquidationPortionPaymentFormCode:
            json['financialTitleLiquidationPortionPaymentFormCode'] as int?,
        financialTitleLiquidationPortionCode:
            json['financialTitleLiquidationPortionCode'] as int?,
        financialTitlePortionCode: json['financialTitlePortionCode'] as int?,
        paymentFormDescription: json['paymentFormDescription'] as String?,
        value: json['value'] as num?,
        expenseAccessory: json['expenseAccessory'] as num?,
        expenseRegistry: json['expenseRegistry'] as num?,
        interest: json['interest'] as num?,
        increment: json['increment'] as num?,
        discount: json['discount'] as num?,
        fine: json['fine'] as num?,
        discountByAnticipatedPay: json['discountByAnticipatedPay'] as num?,
        collectTax: json['collectTax'] as num?,
      );

  factory FinancialTitleLiquidationPaymentFormModel.fromEntity(
          FinancialTitleLiquidationPaymentFormEntity entity) =>
      FinancialTitleLiquidationPaymentFormModel(
        financialTitleLiquidationPortionPaymentFormCode:
            entity.financialTitleLiquidationPortionPaymentFormCode,
        financialTitleLiquidationPortionCode:
            entity.financialTitleLiquidationPortionCode,
        financialTitlePortionCode: entity.financialTitlePortionCode,
        paymentFormDescription: entity.paymentFormDescription,
        value: entity.value,
        expenseAccessory: entity.expenseAccessory,
        expenseRegistry: entity.expenseRegistry,
        interest: entity.interest,
        increment: entity.increment,
        discount: entity.discount,
        fine: entity.fine,
        discountByAnticipatedPay: entity.discountByAnticipatedPay,
        collectTax: entity.collectTax,
      );

  Map<String, dynamic> toJson() => {
        'financialTitleLiquidationPortionPaymentFormCode':
            financialTitleLiquidationPortionPaymentFormCode,
        'financialTitleLiquidationPortionCode':
            financialTitleLiquidationPortionCode,
        'financialTitlePortionCode': financialTitlePortionCode,
        'paymentFormDescription': paymentFormDescription,
        'value': value,
        'expenseAccessory': expenseAccessory,
        'expenseRegistry': expenseRegistry,
        'interest': interest,
        'increment': increment,
        'discount': discount,
        'fine': fine,
        'discountByAnticipatedPay': discountByAnticipatedPay,
        'collectTax': collectTax,
      };

  FinancialTitleLiquidationPaymentFormEntity toEntity() =>
      FinancialTitleLiquidationPaymentFormEntity(
        financialTitleLiquidationPortionPaymentFormCode:
            financialTitleLiquidationPortionPaymentFormCode,
        financialTitleLiquidationPortionCode:
            financialTitleLiquidationPortionCode,
        financialTitlePortionCode: financialTitlePortionCode,
        paymentFormDescription: paymentFormDescription,
        value: value,
        expenseAccessory: expenseAccessory,
        expenseRegistry: expenseRegistry,
        interest: interest,
        increment: increment,
        discount: discount,
        fine: fine,
        discountByAnticipatedPay: discountByAnticipatedPay,
        collectTax: collectTax,
      );
}

import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleCalculatedTotalsModel
    extends FinancialTitleCalculatedTotalsEntity {
  const FinancialTitleCalculatedTotalsModel({
    required super.receiveGrossValue,
    required super.payGrossValue,
    required super.grossBalanceValue,
    required super.receiveLiquidValue,
    required super.payLiquidValue,
    required super.liquidBalanceValue,
    required super.receiveOpenValue,
    required super.payOpenValue,
    required super.openBalanceValue,
    required super.receiveSettledValue,
    required super.paySettledValue,
    required super.settledBalanceValue,
    required super.receiveIncreaseValue,
    required super.payIncreaseValue,
    required super.increaseBalanceValue,
    required super.receiveDiscountValue,
    required super.payDiscountValue,
    required super.discountBalanceValue,
    required super.financialClassificationLiquidValue,
    required super.financialClassificationIncomeExpenseCenterLiquidValue,
  });

  factory FinancialTitleCalculatedTotalsModel.fromJson(Map json) =>
      FinancialTitleCalculatedTotalsModel(
        receiveGrossValue: json['receiveGrossValue'] as num,
        payGrossValue: json['payGrossValue'] as num,
        grossBalanceValue: json['grossBalanceValue'] as num,
        receiveLiquidValue: json['receiveLiquidValue'] as num,
        payLiquidValue: json['payLiquidValue'] as num,
        liquidBalanceValue: json['liquidBalanceValue'] as num,
        receiveOpenValue: json['receiveOpenValue'] as num,
        payOpenValue: json['payOpenValue'] as num,
        openBalanceValue: json['openBalanceValue'] as num,
        receiveSettledValue: json['receiveSettledValue'] as num,
        paySettledValue: json['paySettledValue'] as num,
        settledBalanceValue: json['settledBalanceValue'] as num,
        receiveIncreaseValue: json['receiveIncreaseValue'] as num,
        payIncreaseValue: json['payIncreaseValue'] as num,
        increaseBalanceValue: json['increaseBalanceValue'] as num,
        receiveDiscountValue: json['receiveDiscountValue'] as num,
        payDiscountValue: json['payDiscountValue'] as num,
        discountBalanceValue: json['discountBalanceValue'] as num,
        financialClassificationLiquidValue:
            json['financialClassificationLiquidValue'] as num?,
        financialClassificationIncomeExpenseCenterLiquidValue:
            json['financialClassificationIncomeExpenseCenterLiquidValue']
                as num?,
      );

  factory FinancialTitleCalculatedTotalsModel.fromEntity(
          FinancialTitleCalculatedTotalsEntity entity) =>
      FinancialTitleCalculatedTotalsModel(
        receiveGrossValue: entity.receiveGrossValue,
        payGrossValue: entity.payGrossValue,
        grossBalanceValue: entity.grossBalanceValue,
        receiveLiquidValue: entity.receiveLiquidValue,
        payLiquidValue: entity.payLiquidValue,
        liquidBalanceValue: entity.liquidBalanceValue,
        receiveOpenValue: entity.receiveOpenValue,
        payOpenValue: entity.payOpenValue,
        openBalanceValue: entity.openBalanceValue,
        receiveSettledValue: entity.receiveSettledValue,
        paySettledValue: entity.paySettledValue,
        settledBalanceValue: entity.settledBalanceValue,
        receiveIncreaseValue: entity.receiveIncreaseValue,
        payIncreaseValue: entity.payIncreaseValue,
        increaseBalanceValue: entity.increaseBalanceValue,
        receiveDiscountValue: entity.receiveDiscountValue,
        payDiscountValue: entity.payDiscountValue,
        discountBalanceValue: entity.discountBalanceValue,
        financialClassificationLiquidValue:
            entity.financialClassificationLiquidValue,
        financialClassificationIncomeExpenseCenterLiquidValue:
            entity.financialClassificationIncomeExpenseCenterLiquidValue,
      );

  Map<String, dynamic> toJson() => {
        'receiveGrossValue': receiveGrossValue,
        'payGrossValue': payGrossValue,
        'grossBalanceValue': grossBalanceValue,
        'receiveLiquidValue': receiveLiquidValue,
        'payLiquidValue': payLiquidValue,
        'liquidBalanceValue': liquidBalanceValue,
        'receiveOpenValue': receiveOpenValue,
        'payOpenValue': payOpenValue,
        'openBalanceValue': openBalanceValue,
        'receiveSettledValue': receiveSettledValue,
        'paySettledValue': paySettledValue,
        'settledBalanceValue': settledBalanceValue,
        'receiveIncreaseValue': receiveIncreaseValue,
        'payIncreaseValue': payIncreaseValue,
        'increaseBalanceValue': increaseBalanceValue,
        'receiveDiscountValue': receiveDiscountValue,
        'payDiscountValue': payDiscountValue,
        'discountBalanceValue': discountBalanceValue,
        'financialClassificationLiquidValue':
            financialClassificationLiquidValue,
        'financialClassificationIncomeExpenseCenterLiquidValue':
            financialClassificationIncomeExpenseCenterLiquidValue,
      };

  FinancialTitleCalculatedTotalsEntity toEntity() =>
      FinancialTitleCalculatedTotalsEntity(
        receiveGrossValue: receiveGrossValue,
        payGrossValue: payGrossValue,
        grossBalanceValue: grossBalanceValue,
        receiveLiquidValue: receiveLiquidValue,
        payLiquidValue: payLiquidValue,
        liquidBalanceValue: liquidBalanceValue,
        receiveOpenValue: receiveOpenValue,
        payOpenValue: payOpenValue,
        openBalanceValue: openBalanceValue,
        receiveSettledValue: receiveSettledValue,
        paySettledValue: paySettledValue,
        settledBalanceValue: settledBalanceValue,
        receiveIncreaseValue: receiveIncreaseValue,
        payIncreaseValue: payIncreaseValue,
        increaseBalanceValue: increaseBalanceValue,
        receiveDiscountValue: receiveDiscountValue,
        payDiscountValue: payDiscountValue,
        discountBalanceValue: discountBalanceValue,
        financialClassificationLiquidValue: financialClassificationLiquidValue,
        financialClassificationIncomeExpenseCenterLiquidValue:
            financialClassificationIncomeExpenseCenterLiquidValue,
      );
}

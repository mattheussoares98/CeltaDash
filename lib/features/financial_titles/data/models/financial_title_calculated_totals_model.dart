// lib/features/financial_titles/data/models/financial_title_calculated_totals_model.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class FinancialTitleCalculatedTotalsModel extends Equatable {
  final num receiveGrossValue;
  final num payGrossValue;
  final num grossBalanceValue;
  final num receiveLiquidValue;
  final num payLiquidValue;
  final num liquidBalanceValue;
  final num receiveOpenValue;
  final num payOpenValue;
  final num openBalanceValue;
  final num receiveSettledValue;
  final num paySettledValue;
  final num settledBalanceValue;
  final num receiveIncreaseValue;
  final num payIncreaseValue;
  final num increaseBalanceValue;
  final num receiveDiscountValue;
  final num payDiscountValue;
  final num discountBalanceValue;
  final num? financialClassificationLiquidValue;
  final num? financialClassificationIncomeExpenseCenterLiquidValue;

  const FinancialTitleCalculatedTotalsModel({
    this.receiveGrossValue = 0,
    this.payGrossValue = 0,
    this.grossBalanceValue = 0,
    this.receiveLiquidValue = 0,
    this.payLiquidValue = 0,
    this.liquidBalanceValue = 0,
    this.receiveOpenValue = 0,
    this.payOpenValue = 0,
    this.openBalanceValue = 0,
    this.receiveSettledValue = 0,
    this.paySettledValue = 0,
    this.settledBalanceValue = 0,
    this.receiveIncreaseValue = 0,
    this.payIncreaseValue = 0,
    this.increaseBalanceValue = 0,
    this.receiveDiscountValue = 0,
    this.payDiscountValue = 0,
    this.discountBalanceValue = 0,
    this.financialClassificationLiquidValue,
    this.financialClassificationIncomeExpenseCenterLiquidValue,
  });

  @override
  List<Object?> get props => [
    receiveGrossValue,
    payGrossValue,
    grossBalanceValue,
    receiveLiquidValue,
    payLiquidValue,
    liquidBalanceValue,
    receiveOpenValue,
    payOpenValue,
    openBalanceValue,
    receiveSettledValue,
    paySettledValue,
    settledBalanceValue,
    receiveIncreaseValue,
    payIncreaseValue,
    increaseBalanceValue,
    receiveDiscountValue,
    payDiscountValue,
    discountBalanceValue,
    financialClassificationLiquidValue,
    financialClassificationIncomeExpenseCenterLiquidValue,
  ];

  static num _parseNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    return num.tryParse(value.toString()) ?? 0;
  }

  static num? _parseNullableNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }

  factory FinancialTitleCalculatedTotalsModel.fromJson(Map json) {
    return FinancialTitleCalculatedTotalsModel(
      receiveGrossValue: _parseNum(
        json['ReceiveGrossValue'] ?? json['receiveGrossValue'],
      ),
      payGrossValue: _parseNum(
        json['PayGrossValue'] ?? json['payGrossValue'],
      ),
      grossBalanceValue: _parseNum(
        json['GrossBalanceValue'] ?? json['grossBalanceValue'],
      ),
      receiveLiquidValue: _parseNum(
        json['ReceiveLiquidValue'] ?? json['receiveLiquidValue'],
      ),
      payLiquidValue: _parseNum(
        json['PayLiquidValue'] ?? json['payLiquidValue'],
      ),
      liquidBalanceValue: _parseNum(
        json['LiquidBalanceValue'] ?? json['liquidBalanceValue'],
      ),
      receiveOpenValue: _parseNum(
        json['ReceiveOpenValue'] ?? json['receiveOpenValue'],
      ),
      payOpenValue: _parseNum(json['PayOpenValue'] ?? json['payOpenValue']),
      openBalanceValue: _parseNum(
        json['OpenBalanceValue'] ?? json['openBalanceValue'],
      ),
      receiveSettledValue: _parseNum(
        json['ReceiveSettledValue'] ?? json['receiveSettledValue'],
      ),
      paySettledValue: _parseNum(
        json['PaySettledValue'] ?? json['paySettledValue'],
      ),
      settledBalanceValue: _parseNum(
        json['SettledBalanceValue'] ?? json['settledBalanceValue'],
      ),
      receiveIncreaseValue: _parseNum(
        json['ReceiveIncreaseValue'] ?? json['receiveIncreaseValue'],
      ),
      payIncreaseValue: _parseNum(
        json['PayIncreaseValue'] ?? json['payIncreaseValue'],
      ),
      increaseBalanceValue: _parseNum(
        json['IncreaseBalanceValue'] ?? json['increaseBalanceValue'],
      ),
      receiveDiscountValue: _parseNum(
        json['ReceiveDiscountValue'] ?? json['receiveDiscountValue'],
      ),
      payDiscountValue: _parseNum(
        json['PayDiscountValue'] ?? json['payDiscountValue'],
      ),
      discountBalanceValue: _parseNum(
        json['DiscountBalanceValue'] ?? json['discountBalanceValue'],
      ),
      financialClassificationLiquidValue: _parseNullableNum(
        json['FinancialClassificationLiquidValue'] ??
            json['financialClassificationLiquidValue'],
      ),
      financialClassificationIncomeExpenseCenterLiquidValue: _parseNullableNum(
        json['FinancialClassificationIncomeExpenseCenterLiquidValue'] ??
            json['financialClassificationIncomeExpenseCenterLiquidValue'],
      ),
    );
  }

  factory FinancialTitleCalculatedTotalsModel.fromEntity(
    FinancialTitleCalculatedTotalsEntity entity,
  ) {
    return FinancialTitleCalculatedTotalsModel(
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
  }

  FinancialTitleCalculatedTotalsEntity toEntity() {
    return FinancialTitleCalculatedTotalsEntity(
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

  Map toJson() => {
    'ReceiveGrossValue': receiveGrossValue,
    'PayGrossValue': payGrossValue,
    'GrossBalanceValue': grossBalanceValue,
    'ReceiveLiquidValue': receiveLiquidValue,
    'PayLiquidValue': payLiquidValue,
    'LiquidBalanceValue': liquidBalanceValue,
    'ReceiveOpenValue': receiveOpenValue,
    'PayOpenValue': payOpenValue,
    'OpenBalanceValue': openBalanceValue,
    'ReceiveSettledValue': receiveSettledValue,
    'PaySettledValue': paySettledValue,
    'SettledBalanceValue': settledBalanceValue,
    'ReceiveIncreaseValue': receiveIncreaseValue,
    'PayIncreaseValue': payIncreaseValue,
    'IncreaseBalanceValue': increaseBalanceValue,
    'ReceiveDiscountValue': receiveDiscountValue,
    'PayDiscountValue': payDiscountValue,
    'DiscountBalanceValue': discountBalanceValue,
    'FinancialClassificationLiquidValue': financialClassificationLiquidValue,
    'FinancialClassificationIncomeExpenseCenterLiquidValue':
        financialClassificationIncomeExpenseCenterLiquidValue,
  };
}

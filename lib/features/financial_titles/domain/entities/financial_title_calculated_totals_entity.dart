// lib/features/financial_titles/domain/entities/financial_title_calculated_totals_entity.dart
import 'package:equatable/equatable.dart';

class FinancialTitleCalculatedTotalsEntity extends Equatable {
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

  const FinancialTitleCalculatedTotalsEntity({
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
}

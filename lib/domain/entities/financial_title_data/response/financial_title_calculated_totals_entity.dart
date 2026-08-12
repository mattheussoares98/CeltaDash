import 'package:equatable/equatable.dart';

/// Calculated totals returned by Commerce API.
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
    required this.receiveGrossValue,
    required this.payGrossValue,
    required this.grossBalanceValue,
    required this.receiveLiquidValue,
    required this.payLiquidValue,
    required this.liquidBalanceValue,
    required this.receiveOpenValue,
    required this.payOpenValue,
    required this.openBalanceValue,
    required this.receiveSettledValue,
    required this.paySettledValue,
    required this.settledBalanceValue,
    required this.receiveIncreaseValue,
    required this.payIncreaseValue,
    required this.increaseBalanceValue,
    required this.receiveDiscountValue,
    required this.payDiscountValue,
    required this.discountBalanceValue,
    required this.financialClassificationLiquidValue,
    required this.financialClassificationIncomeExpenseCenterLiquidValue,
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

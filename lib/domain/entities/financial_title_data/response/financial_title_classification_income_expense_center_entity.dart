import 'package:equatable/equatable.dart';

/// Classification and income/expense-center allocation returned by Commerce API.
class FinancialTitleClassificationIncomeExpenseCenterEntity extends Equatable {
  final int financialTitlePortionCode;
  final int financialClassificationCode;
  final int incomeExpenseCenterCode;
  final num financialClassificationPercentage;
  final num incomeExpenseCenterPercentage;
  final String? incomeExpenseCenter;
  final num liquidValue;
  final num settledValue;

  const FinancialTitleClassificationIncomeExpenseCenterEntity({
    required this.financialTitlePortionCode,
    required this.financialClassificationCode,
    required this.incomeExpenseCenterCode,
    required this.financialClassificationPercentage,
    required this.incomeExpenseCenterPercentage,
    required this.incomeExpenseCenter,
    required this.liquidValue,
    required this.settledValue,
  });

  @override
  List<Object?> get props => [
        financialTitlePortionCode,
        financialClassificationCode,
        incomeExpenseCenterCode,
        financialClassificationPercentage,
        incomeExpenseCenterPercentage,
        incomeExpenseCenter,
        liquidValue,
        settledValue,
      ];
}

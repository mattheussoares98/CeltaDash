import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleClassificationIncomeExpenseCenterModel
    extends FinancialTitleClassificationIncomeExpenseCenterEntity {
  const FinancialTitleClassificationIncomeExpenseCenterModel({
    required super.financialTitlePortionCode,
    required super.financialClassificationCode,
    required super.incomeExpenseCenterCode,
    required super.financialClassificationPercentage,
    required super.incomeExpenseCenterPercentage,
    required super.incomeExpenseCenter,
    required super.liquidValue,
    required super.settledValue,
  });

  factory FinancialTitleClassificationIncomeExpenseCenterModel.fromJson(
          Map json) =>
      FinancialTitleClassificationIncomeExpenseCenterModel(
        financialTitlePortionCode: json['financialTitlePortionCode'] as int,
        financialClassificationCode: json['financialClassificationCode'] as int,
        incomeExpenseCenterCode: json['incomeExpenseCenterCode'] as int,
        financialClassificationPercentage:
            json['financialClassificationPercentage'] as num,
        incomeExpenseCenterPercentage:
            json['incomeExpenseCenterPercentage'] as num,
        incomeExpenseCenter: json['incomeExpenseCenter'] as String?,
        liquidValue: json['liquidValue'] as num,
        settledValue: json['settledValue'] as num,
      );

  factory FinancialTitleClassificationIncomeExpenseCenterModel.fromEntity(
          FinancialTitleClassificationIncomeExpenseCenterEntity entity) =>
      FinancialTitleClassificationIncomeExpenseCenterModel(
        financialTitlePortionCode: entity.financialTitlePortionCode,
        financialClassificationCode: entity.financialClassificationCode,
        incomeExpenseCenterCode: entity.incomeExpenseCenterCode,
        financialClassificationPercentage:
            entity.financialClassificationPercentage,
        incomeExpenseCenterPercentage: entity.incomeExpenseCenterPercentage,
        incomeExpenseCenter: entity.incomeExpenseCenter,
        liquidValue: entity.liquidValue,
        settledValue: entity.settledValue,
      );

  Map<String, dynamic> toJson() => {
        'financialTitlePortionCode': financialTitlePortionCode,
        'financialClassificationCode': financialClassificationCode,
        'incomeExpenseCenterCode': incomeExpenseCenterCode,
        'financialClassificationPercentage': financialClassificationPercentage,
        'incomeExpenseCenterPercentage': incomeExpenseCenterPercentage,
        'incomeExpenseCenter': incomeExpenseCenter,
        'liquidValue': liquidValue,
        'settledValue': settledValue,
      };

  FinancialTitleClassificationIncomeExpenseCenterEntity toEntity() =>
      FinancialTitleClassificationIncomeExpenseCenterEntity(
        financialTitlePortionCode: financialTitlePortionCode,
        financialClassificationCode: financialClassificationCode,
        incomeExpenseCenterCode: incomeExpenseCenterCode,
        financialClassificationPercentage: financialClassificationPercentage,
        incomeExpenseCenterPercentage: incomeExpenseCenterPercentage,
        incomeExpenseCenter: incomeExpenseCenter,
        liquidValue: liquidValue,
        settledValue: settledValue,
      );
}

import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleIncomeExpenseCenterModel
    extends FinancialTitleIncomeExpenseCenterEntity {
  const FinancialTitleIncomeExpenseCenterModel({
    required super.code,
    required super.personalizedCode,
    required super.description,
  });

  factory FinancialTitleIncomeExpenseCenterModel.fromJson(Map json) =>
      FinancialTitleIncomeExpenseCenterModel(
        code: json['code'] as int?,
        personalizedCode: json['personalizedCode'] as String?,
        description: json['description'] as String?,
      );

  factory FinancialTitleIncomeExpenseCenterModel.fromEntity(
          FinancialTitleIncomeExpenseCenterEntity entity) =>
      FinancialTitleIncomeExpenseCenterModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
        description: entity.description,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'personalizedCode': personalizedCode,
        'description': description,
      };

  FinancialTitleIncomeExpenseCenterEntity toEntity() =>
      FinancialTitleIncomeExpenseCenterEntity(
        code: code,
        personalizedCode: personalizedCode,
        description: description,
      );
}

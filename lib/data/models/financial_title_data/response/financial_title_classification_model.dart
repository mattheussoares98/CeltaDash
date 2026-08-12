import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleClassificationModel
    extends FinancialTitleClassificationEntity {
  const FinancialTitleClassificationModel({
    required super.financialTitlePortionCode,
    required super.financialClassificationCode,
    required super.apportionmentPercentage,
    required super.group,
    required super.category,
    required super.subCategory,
    required super.liquidValue,
    required super.settledValue,
  });

  factory FinancialTitleClassificationModel.fromJson(Map json) =>
      FinancialTitleClassificationModel(
        financialTitlePortionCode: json['financialTitlePortionCode'] as int,
        financialClassificationCode: json['financialClassificationCode'] as int,
        apportionmentPercentage: json['apportionmentPercentage'] as num,
        group: json['group'] as String?,
        category: json['category'] as String?,
        subCategory: json['subCategory'] as String?,
        liquidValue: json['liquidValue'] as num,
        settledValue: json['settledValue'] as num,
      );

  factory FinancialTitleClassificationModel.fromEntity(
          FinancialTitleClassificationEntity entity) =>
      FinancialTitleClassificationModel(
        financialTitlePortionCode: entity.financialTitlePortionCode,
        financialClassificationCode: entity.financialClassificationCode,
        apportionmentPercentage: entity.apportionmentPercentage,
        group: entity.group,
        category: entity.category,
        subCategory: entity.subCategory,
        liquidValue: entity.liquidValue,
        settledValue: entity.settledValue,
      );

  Map<String, dynamic> toJson() => {
        'financialTitlePortionCode': financialTitlePortionCode,
        'financialClassificationCode': financialClassificationCode,
        'apportionmentPercentage': apportionmentPercentage,
        'group': group,
        'category': category,
        'subCategory': subCategory,
        'liquidValue': liquidValue,
        'settledValue': settledValue,
      };

  FinancialTitleClassificationEntity toEntity() =>
      FinancialTitleClassificationEntity(
        financialTitlePortionCode: financialTitlePortionCode,
        financialClassificationCode: financialClassificationCode,
        apportionmentPercentage: apportionmentPercentage,
        group: group,
        category: category,
        subCategory: subCategory,
        liquidValue: liquidValue,
        settledValue: settledValue,
      );
}

// lib/features/financial_titles/data/models/financial_title_classification_model.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class FinancialTitleClassificationModel extends Equatable {
  final int? financialTitlePortionCode;
  final int? financialClassificationCode;
  final num? apportionmentPercentage;
  final String? group;
  final String? category;
  final String? subCategory;
  final num? liquidValue;
  final num? settledValue;

  const FinancialTitleClassificationModel({
    this.financialTitlePortionCode,
    this.financialClassificationCode,
    this.apportionmentPercentage,
    this.group,
    this.category,
    this.subCategory,
    this.liquidValue,
    this.settledValue,
  });

  @override
  List<Object?> get props => [
    financialTitlePortionCode,
    financialClassificationCode,
    apportionmentPercentage,
    group,
    category,
    subCategory,
    liquidValue,
    settledValue,
  ];

  static num? _parseNullableNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }

  factory FinancialTitleClassificationModel.fromJson(Map json) {
    return FinancialTitleClassificationModel(
      financialTitlePortionCode:
          json['FinancialTitlePortionCode'] ?? json['financialTitlePortionCode'],
      financialClassificationCode:
          json['FinancialClassificationCode'] ??
          json['financialClassificationCode'],
      apportionmentPercentage: _parseNullableNum(
        json['ApportionmentPercentage'] ?? json['apportionmentPercentage'],
      ),
      group: json['Group'] ?? json['group'],
      category: json['Category'] ?? json['category'],
      subCategory: json['SubCategory'] ?? json['subCategory'],
      liquidValue: _parseNullableNum(
        json['LiquidValue'] ?? json['liquidValue'],
      ),
      settledValue: _parseNullableNum(
        json['SettledValue'] ?? json['settledValue'],
      ),
    );
  }

  factory FinancialTitleClassificationModel.fromEntity(
    FinancialTitleClassificationEntity entity,
  ) {
    return FinancialTitleClassificationModel(
      financialTitlePortionCode: entity.financialTitlePortionCode,
      financialClassificationCode: entity.financialClassificationCode,
      apportionmentPercentage: entity.apportionmentPercentage,
      group: entity.group,
      category: entity.category,
      subCategory: entity.subCategory,
      liquidValue: entity.liquidValue,
      settledValue: entity.settledValue,
    );
  }

  FinancialTitleClassificationEntity toEntity() {
    return FinancialTitleClassificationEntity(
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

  Map toJson() => {
    'FinancialTitlePortionCode': financialTitlePortionCode,
    'FinancialClassificationCode': financialClassificationCode,
    'ApportionmentPercentage': apportionmentPercentage,
    'Group': group,
    'Category': category,
    'SubCategory': subCategory,
    'LiquidValue': liquidValue,
    'SettledValue': settledValue,
  };
}

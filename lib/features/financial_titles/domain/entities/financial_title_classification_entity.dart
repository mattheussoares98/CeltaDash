// lib/features/financial_titles/domain/entities/financial_title_classification_entity.dart
import 'package:equatable/equatable.dart';

class FinancialTitleClassificationEntity extends Equatable {
  final int? financialTitlePortionCode;
  final int? financialClassificationCode;
  final num? apportionmentPercentage;
  final String? group;
  final String? category;
  final String? subCategory;
  final num? liquidValue;
  final num? settledValue;

  const FinancialTitleClassificationEntity({
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
}

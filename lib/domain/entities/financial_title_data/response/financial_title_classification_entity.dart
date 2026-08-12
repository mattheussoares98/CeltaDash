import 'package:equatable/equatable.dart';

/// Financial classification returned by Commerce API.
class FinancialTitleClassificationEntity extends Equatable {
  final int financialTitlePortionCode;
  final int financialClassificationCode;
  final num apportionmentPercentage;
  final String? group;
  final String? category;
  final String? subCategory;
  final num liquidValue;
  final num settledValue;

  const FinancialTitleClassificationEntity({
    required this.financialTitlePortionCode,
    required this.financialClassificationCode,
    required this.apportionmentPercentage,
    required this.group,
    required this.category,
    required this.subCategory,
    required this.liquidValue,
    required this.settledValue,
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

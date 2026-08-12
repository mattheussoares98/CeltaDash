import 'package:equatable/equatable.dart';

import '../request/financial_title_type.dart';

class FinancialTitleRetroactivePositionEntity extends Equatable {
  final int? enterpriseCode;
  final FinancialTitleType? financialTitleType;
  final num? grossValue;
  final num? openValue;

  const FinancialTitleRetroactivePositionEntity({
    required this.enterpriseCode,
    required this.financialTitleType,
    required this.grossValue,
    required this.openValue,
  });

  @override
  List<Object?> get props => [
        enterpriseCode,
        financialTitleType,
        grossValue,
        openValue,
      ];
}

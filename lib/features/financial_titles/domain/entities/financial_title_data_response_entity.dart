// lib/features/financial_titles/domain/entities/financial_title_data_response_entity.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class FinancialTitleDataResponseEntity extends Equatable {
  final SearchFinancialTitleDataParams? searchParameters;
  final List<FinancialTitleDataRowEntity> financialTitlePortions;
  final List<FinancialTitleDataRowEntity>? comparisonFinancialTitlePortions;
  final FinancialTitleCalculatedTotalsEntity? calculatedTotals;
  final List<FinancialTitleClassificationEntity>? financialClassifications;

  const FinancialTitleDataResponseEntity({
    this.searchParameters,
    this.financialTitlePortions = const [],
    this.comparisonFinancialTitlePortions,
    this.calculatedTotals,
    this.financialClassifications,
  });

  @override
  List<Object?> get props => [
    searchParameters,
    financialTitlePortions,
    comparisonFinancialTitlePortions,
    calculatedTotals,
    financialClassifications,
  ];
}

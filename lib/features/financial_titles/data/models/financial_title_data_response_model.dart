// lib/features/financial_titles/data/models/financial_title_data_response_model.dart
import 'package:celta_dash/features/financial_titles/data/models/models.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class FinancialTitleDataResponseModel extends Equatable {
  final List<FinancialTitleDataRowModel> financialTitlePortions;
  final List<FinancialTitleDataRowModel>? comparisonFinancialTitlePortions;
  final FinancialTitleCalculatedTotalsModel? calculatedTotals;
  final List<FinancialTitleClassificationModel>? financialClassifications;

  const FinancialTitleDataResponseModel({
    this.financialTitlePortions = const [],
    this.comparisonFinancialTitlePortions,
    this.calculatedTotals,
    this.financialClassifications,
  });

  @override
  List<Object?> get props => [
    financialTitlePortions,
    comparisonFinancialTitlePortions,
    calculatedTotals,
    financialClassifications,
  ];

  factory FinancialTitleDataResponseModel.fromJson(Map json) {
    final portionsList =
        (json['FinancialTitlePortions'] ?? json['financialTitlePortions'])
            as List?;
    final comparisonList =
        (json['ComparisonFinancialTitlePortions'] ??
                json['comparisonFinancialTitlePortions'])
            as List?;
    final totalsMap =
        (json['CalculatedTotals'] ?? json['calculatedTotals']) as Map?;
    final classificationsList =
        (json['FinancialClassifications'] ?? json['financialClassifications'])
            as List?;

    return FinancialTitleDataResponseModel(
      financialTitlePortions:
          portionsList
              ?.map(
                (e) => FinancialTitleDataRowModel.fromJson(e as Map? ?? {}),
              )
              .toList() ??
          const [],
      comparisonFinancialTitlePortions: comparisonList
          ?.map((e) => FinancialTitleDataRowModel.fromJson(e as Map? ?? {}))
          .toList(),
      calculatedTotals: totalsMap != null
          ? FinancialTitleCalculatedTotalsModel.fromJson(totalsMap)
          : null,
      financialClassifications: classificationsList
          ?.map(
            (e) =>
                FinancialTitleClassificationModel.fromJson(e as Map? ?? {}),
          )
          .toList(),
    );
  }

  factory FinancialTitleDataResponseModel.fromEntity(
    FinancialTitleDataResponseEntity entity,
  ) {
    return FinancialTitleDataResponseModel(
      financialTitlePortions: entity.financialTitlePortions
          .map(FinancialTitleDataRowModel.fromEntity)
          .toList(),
      comparisonFinancialTitlePortions: entity
          .comparisonFinancialTitlePortions
          ?.map(FinancialTitleDataRowModel.fromEntity)
          .toList(),
      calculatedTotals: entity.calculatedTotals != null
          ? FinancialTitleCalculatedTotalsModel.fromEntity(
              entity.calculatedTotals!,
            )
          : null,
      financialClassifications: entity.financialClassifications
          ?.map(FinancialTitleClassificationModel.fromEntity)
          .toList(),
    );
  }

  FinancialTitleDataResponseEntity toEntity({
    SearchFinancialTitleDataParams? searchParameters,
  }) {
    return FinancialTitleDataResponseEntity(
      searchParameters: searchParameters,
      financialTitlePortions:
          financialTitlePortions.map((e) => e.toEntity()).toList(),
      comparisonFinancialTitlePortions: comparisonFinancialTitlePortions
          ?.map((e) => e.toEntity())
          .toList(),
      calculatedTotals: calculatedTotals?.toEntity(),
      financialClassifications:
          financialClassifications?.map((e) => e.toEntity()).toList(),
    );
  }

  Map toJson() => {
    'FinancialTitlePortions':
        financialTitlePortions.map((e) => e.toJson()).toList(),
    if (comparisonFinancialTitlePortions != null)
      'ComparisonFinancialTitlePortions':
          comparisonFinancialTitlePortions!.map((e) => e.toJson()).toList(),
    if (calculatedTotals != null) 'CalculatedTotals': calculatedTotals!.toJson(),
    if (financialClassifications != null)
      'FinancialClassifications':
          financialClassifications!.map((e) => e.toJson()).toList(),
  };
}

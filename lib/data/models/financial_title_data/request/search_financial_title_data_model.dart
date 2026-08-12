import 'package:celta_dash/domain/entities/entities.dart';

import 'financial_title_period_model.dart';

class SearchFinancialTitleDataModel extends SearchFinancialTitleDataParams {
  const SearchFinancialTitleDataModel({
    required super.enterpriseCodes,
    required super.financialTitleTypes,
    required super.situations,
    required super.periodType,
    required super.period,
    super.comparisonPeriod,
    super.positionDate,
    super.documentNumbers,
    super.documentTypeCodes,
    super.treasuryAccountCodes,
    super.cadasterTypes,
    super.cadasterCodes,
    super.financialClassificationCodes,
    super.excludeFinancialClassifications,
    super.periodGrouping,
    super.mountPortionPayments,
    super.mountPortionsAdministrativeTax,
    super.mountLiquidationPortions,
    super.mountLiquidationPortionPaymentForms,
    super.mountRetroactivePosition,
    super.mountEnterprises,
    super.mountUnitGroups,
    super.mountControlDocuments,
    super.mountIncomeExpenseCenters,
    super.mountFinancialClassifications,
    super.mountFinancialClassificationIncomeExpenseCenters,
    super.mountComparisonPeriod,
    super.mountCalculatedTotals,
  });

  factory SearchFinancialTitleDataModel.fromJson(Map json) =>
      SearchFinancialTitleDataModel(
        enterpriseCodes: List<int>.from(json['enterpriseCodes'] as List),
        financialTitleTypes: (json['financialTitleTypes'] as List)
            .map((value) => FinancialTitleType.fromValue(value as int)!)
            .toList(),
        situations: (json['situations'] as List)
            .map((value) => FinancialTitleSituation.fromValue(value as int)!)
            .toList(),
        periodType:
            FinancialTitlePeriodType.fromValue(json['periodType'] as int)!,
        period: FinancialTitlePeriodModel.fromJson(json['period'] as Map),
        comparisonPeriod: json['comparisonPeriod'] == null
            ? null
            : FinancialTitlePeriodModel.fromJson(
                json['comparisonPeriod'] as Map,
              ),
        positionDate: json['positionDate'] == null
            ? null
            : DateTime.parse(json['positionDate'] as String),
        documentNumbers: (json['documentNumbers'] as List?)?.cast<String>(),
        documentTypeCodes: (json['documentTypeCodes'] as List?)?.cast<int>(),
        treasuryAccountCodes:
            (json['treasuryAccountCodes'] as List?)?.cast<int>(),
        cadasterTypes: (json['cadasterTypes'] as List?)
            ?.map(
                (value) => FinancialTitleCadasterType.fromValue(value as int)!)
            .toList(),
        cadasterCodes: (json['cadasterCodes'] as List?)?.cast<int>(),
        financialClassificationCodes:
            (json['financialClassificationCodes'] as List?)?.cast<int>(),
        excludeFinancialClassifications:
            json['excludeFinancialClassifications'] as bool? ?? false,
        periodGrouping: FinancialTitlePeriodGrouping.fromValue(
          json['periodGrouping'] as int?,
        ),
        mountPortionPayments: json['mountPortionPayments'] as bool? ?? false,
        mountPortionsAdministrativeTax:
            json['mountPortionsAdministrativeTax'] as bool? ?? false,
        mountLiquidationPortions:
            json['mountLiquidationPortions'] as bool? ?? false,
        mountLiquidationPortionPaymentForms:
            json['mountLiquidationPortionPaymentForms'] as bool? ?? false,
        mountRetroactivePosition:
            json['mountRetroactivePosition'] as bool? ?? false,
        mountEnterprises: json['mountEnterprises'] as bool? ?? false,
        mountUnitGroups: json['mountUnitGroups'] as bool? ?? false,
        mountControlDocuments: json['mountControlDocuments'] as bool? ?? false,
        mountIncomeExpenseCenters:
            json['mountIncomeExpenseCenters'] as bool? ?? false,
        mountFinancialClassifications:
            json['mountFinancialClassifications'] as bool? ?? false,
        mountFinancialClassificationIncomeExpenseCenters:
            json['mountFinancialClassificationIncomeExpenseCenters'] as bool? ??
                false,
        mountComparisonPeriod: json['mountComparisonPeriod'] as bool? ?? false,
        mountCalculatedTotals: json['mountCalculatedTotals'] as bool? ?? false,
      );

  factory SearchFinancialTitleDataModel.fromEntity(
    SearchFinancialTitleDataParams entity,
  ) =>
      SearchFinancialTitleDataModel(
        enterpriseCodes: entity.enterpriseCodes,
        financialTitleTypes: entity.financialTitleTypes,
        situations: entity.situations,
        periodType: entity.periodType,
        period: FinancialTitlePeriodModel.fromEntity(entity.period),
        comparisonPeriod: entity.comparisonPeriod == null
            ? null
            : FinancialTitlePeriodModel.fromEntity(entity.comparisonPeriod!),
        positionDate: entity.positionDate,
        documentNumbers: entity.documentNumbers,
        documentTypeCodes: entity.documentTypeCodes,
        treasuryAccountCodes: entity.treasuryAccountCodes,
        cadasterTypes: entity.cadasterTypes,
        cadasterCodes: entity.cadasterCodes,
        financialClassificationCodes: entity.financialClassificationCodes,
        excludeFinancialClassifications: entity.excludeFinancialClassifications,
        periodGrouping: entity.periodGrouping,
        mountPortionPayments: entity.mountPortionPayments,
        mountPortionsAdministrativeTax: entity.mountPortionsAdministrativeTax,
        mountLiquidationPortions: entity.mountLiquidationPortions,
        mountLiquidationPortionPaymentForms:
            entity.mountLiquidationPortionPaymentForms,
        mountRetroactivePosition: entity.mountRetroactivePosition,
        mountEnterprises: entity.mountEnterprises,
        mountUnitGroups: entity.mountUnitGroups,
        mountControlDocuments: entity.mountControlDocuments,
        mountIncomeExpenseCenters: entity.mountIncomeExpenseCenters,
        mountFinancialClassifications: entity.mountFinancialClassifications,
        mountFinancialClassificationIncomeExpenseCenters:
            entity.mountFinancialClassificationIncomeExpenseCenters,
        mountComparisonPeriod: entity.mountComparisonPeriod,
        mountCalculatedTotals: entity.mountCalculatedTotals,
      );

  Map<String, dynamic> toJson() => {
        'enterpriseCodes': enterpriseCodes,
        'financialTitleTypes': financialTitleTypes.map((e) => e.value).toList(),
        'situations': situations.map((e) => e.value).toList(),
        'periodType': periodType.value,
        'period': FinancialTitlePeriodModel.fromEntity(period).toJson(),
        'comparisonPeriod': comparisonPeriod == null
            ? null
            : FinancialTitlePeriodModel.fromEntity(comparisonPeriod!).toJson(),
        'positionDate': positionDate?.toIso8601String(),
        'documentNumbers': documentNumbers,
        'documentTypeCodes': documentTypeCodes,
        'treasuryAccountCodes': treasuryAccountCodes,
        'cadasterTypes': cadasterTypes?.map((e) => e.value).toList(),
        'cadasterCodes': cadasterCodes,
        'financialClassificationCodes': financialClassificationCodes,
        'excludeFinancialClassifications': excludeFinancialClassifications,
        'periodGrouping': periodGrouping?.value,
        'mountPortionPayments': mountPortionPayments,
        'mountPortionsAdministrativeTax': mountPortionsAdministrativeTax,
        'mountLiquidationPortions': mountLiquidationPortions,
        'mountLiquidationPortionPaymentForms':
            mountLiquidationPortionPaymentForms,
        'mountRetroactivePosition': mountRetroactivePosition,
        'mountEnterprises': mountEnterprises,
        'mountUnitGroups': mountUnitGroups,
        'mountControlDocuments': mountControlDocuments,
        'mountIncomeExpenseCenters': mountIncomeExpenseCenters,
        'mountFinancialClassifications': mountFinancialClassifications,
        'mountFinancialClassificationIncomeExpenseCenters':
            mountFinancialClassificationIncomeExpenseCenters,
        'mountComparisonPeriod': mountComparisonPeriod,
        'mountCalculatedTotals': mountCalculatedTotals,
      };

  SearchFinancialTitleDataParams toEntity() => SearchFinancialTitleDataParams(
        enterpriseCodes: enterpriseCodes,
        financialTitleTypes: financialTitleTypes,
        situations: situations,
        periodType: periodType,
        period: FinancialTitlePeriodModel.fromEntity(period).toEntity(),
        comparisonPeriod: comparisonPeriod == null
            ? null
            : FinancialTitlePeriodModel.fromEntity(comparisonPeriod!)
                .toEntity(),
        positionDate: positionDate,
        documentNumbers: documentNumbers,
        documentTypeCodes: documentTypeCodes,
        treasuryAccountCodes: treasuryAccountCodes,
        cadasterTypes: cadasterTypes,
        cadasterCodes: cadasterCodes,
        financialClassificationCodes: financialClassificationCodes,
        excludeFinancialClassifications: excludeFinancialClassifications,
        periodGrouping: periodGrouping,
        mountPortionPayments: mountPortionPayments,
        mountPortionsAdministrativeTax: mountPortionsAdministrativeTax,
        mountLiquidationPortions: mountLiquidationPortions,
        mountLiquidationPortionPaymentForms:
            mountLiquidationPortionPaymentForms,
        mountRetroactivePosition: mountRetroactivePosition,
        mountEnterprises: mountEnterprises,
        mountUnitGroups: mountUnitGroups,
        mountControlDocuments: mountControlDocuments,
        mountIncomeExpenseCenters: mountIncomeExpenseCenters,
        mountFinancialClassifications: mountFinancialClassifications,
        mountFinancialClassificationIncomeExpenseCenters:
            mountFinancialClassificationIncomeExpenseCenters,
        mountComparisonPeriod: mountComparisonPeriod,
        mountCalculatedTotals: mountCalculatedTotals,
      );
}

// lib/features/financial_titles/domain/entities/search_financial_title_data_params.dart
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SearchFinancialTitleDataParams extends Equatable
    implements DateRangeParams {
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final List<int>? enterpriseIds;

  final List<int> enterpriseCodes;
  final List<FinancialTitleType> financialTitleTypes;
  final List<FinancialTitleSituation> situations;
  final FinancialTitlePeriodType periodType;
  final DateTime? comparisonStartDate;
  final DateTime? comparisonEndDate;
  final DateTime? positionDate;
  final List<String>? documentNumbers;
  final List<int>? documentTypeCodes;
  final List<int>? treasuryAccountCodes;
  final List<FinancialTitleCadasterType>? cadasterTypes;
  final List<int>? cadasterCodes;
  final List<int>? financialClassificationCodes;
  final bool excludeFinancialClassifications;
  final FinancialTitlePeriodGrouping? periodGrouping;
  final bool groupByEnterprise;
  final bool mountPortionPayments;
  final bool mountPortionsAdministrativeTax;
  final bool mountLiquidationPortions;
  final bool mountLiquidationPortionPaymentForms;
  final bool mountRetroactivePosition;
  final bool mountEnterprises;
  final bool mountUnitGroups;
  final bool mountControlDocuments;
  final bool mountIncomeExpenseCenters;
  final bool mountFinancialClassifications;
  final bool mountFinancialClassificationIncomeExpenseCenters;
  final bool mountComparisonPeriod;
  final bool mountCalculatedTotals;

  const SearchFinancialTitleDataParams({
    required this.startDate,
    required this.endDate,
    required this.enterpriseCodes,
    this.financialTitleTypes = const [
      FinancialTitleType.receive,
      FinancialTitleType.toPay,
    ],
    this.situations = const [
      FinancialTitleSituation.open,
      FinancialTitleSituation.partiallySettled,
      FinancialTitleSituation.completelySettled,
    ],
    this.periodType = FinancialTitlePeriodType.emission,
    this.comparisonStartDate,
    this.comparisonEndDate,
    this.positionDate,
    this.documentNumbers,
    this.documentTypeCodes,
    this.treasuryAccountCodes,
    this.cadasterTypes,
    this.cadasterCodes,
    this.financialClassificationCodes,
    this.excludeFinancialClassifications = false,
    this.periodGrouping,
    this.groupByEnterprise = false,
    this.mountPortionPayments = false,
    this.mountPortionsAdministrativeTax = false,
    this.mountLiquidationPortions = false,
    this.mountLiquidationPortionPaymentForms = false,
    this.mountRetroactivePosition = false,
    this.mountEnterprises = false,
    this.mountUnitGroups = false,
    this.mountControlDocuments = false,
    this.mountIncomeExpenseCenters = false,
    this.mountFinancialClassifications = false,
    this.mountFinancialClassificationIncomeExpenseCenters = false,
    this.mountComparisonPeriod = false,
    this.mountCalculatedTotals = true,
  }) : enterpriseIds = enterpriseCodes;

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    enterpriseCodes,
    financialTitleTypes,
    situations,
    periodType,
    comparisonStartDate,
    comparisonEndDate,
    positionDate,
    documentNumbers,
    documentTypeCodes,
    treasuryAccountCodes,
    cadasterTypes,
    cadasterCodes,
    financialClassificationCodes,
    excludeFinancialClassifications,
    periodGrouping,
    groupByEnterprise,
    mountPortionPayments,
    mountPortionsAdministrativeTax,
    mountLiquidationPortions,
    mountLiquidationPortionPaymentForms,
    mountRetroactivePosition,
    mountEnterprises,
    mountUnitGroups,
    mountControlDocuments,
    mountIncomeExpenseCenters,
    mountFinancialClassifications,
    mountFinancialClassificationIncomeExpenseCenters,
    mountComparisonPeriod,
    mountCalculatedTotals,
  ];

  SearchFinancialTitleDataParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<int>? enterpriseCodes,
    List<FinancialTitleType>? financialTitleTypes,
    List<FinancialTitleSituation>? situations,
    FinancialTitlePeriodType? periodType,
    DateTime? comparisonStartDate,
    DateTime? comparisonEndDate,
    DateTime? positionDate,
    List<String>? documentNumbers,
    List<int>? documentTypeCodes,
    List<int>? treasuryAccountCodes,
    List<FinancialTitleCadasterType>? cadasterTypes,
    List<int>? cadasterCodes,
    List<int>? financialClassificationCodes,
    bool? excludeFinancialClassifications,
    FinancialTitlePeriodGrouping? periodGrouping,
    bool? groupByEnterprise,
    bool? mountPortionPayments,
    bool? mountPortionsAdministrativeTax,
    bool? mountLiquidationPortions,
    bool? mountLiquidationPortionPaymentForms,
    bool? mountRetroactivePosition,
    bool? mountEnterprises,
    bool? mountUnitGroups,
    bool? mountControlDocuments,
    bool? mountIncomeExpenseCenters,
    bool? mountFinancialClassifications,
    bool? mountFinancialClassificationIncomeExpenseCenters,
    bool? mountComparisonPeriod,
    bool? mountCalculatedTotals,
  }) {
    return SearchFinancialTitleDataParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      enterpriseCodes: enterpriseCodes ?? this.enterpriseCodes,
      financialTitleTypes: financialTitleTypes ?? this.financialTitleTypes,
      situations: situations ?? this.situations,
      periodType: periodType ?? this.periodType,
      comparisonStartDate: comparisonStartDate ?? this.comparisonStartDate,
      comparisonEndDate: comparisonEndDate ?? this.comparisonEndDate,
      positionDate: positionDate ?? this.positionDate,
      documentNumbers: documentNumbers ?? this.documentNumbers,
      documentTypeCodes: documentTypeCodes ?? this.documentTypeCodes,
      treasuryAccountCodes: treasuryAccountCodes ?? this.treasuryAccountCodes,
      cadasterTypes: cadasterTypes ?? this.cadasterTypes,
      cadasterCodes: cadasterCodes ?? this.cadasterCodes,
      financialClassificationCodes:
          financialClassificationCodes ?? this.financialClassificationCodes,
      excludeFinancialClassifications:
          excludeFinancialClassifications ??
          this.excludeFinancialClassifications,
      periodGrouping: periodGrouping ?? this.periodGrouping,
      groupByEnterprise: groupByEnterprise ?? this.groupByEnterprise,
      mountPortionPayments: mountPortionPayments ?? this.mountPortionPayments,
      mountPortionsAdministrativeTax:
          mountPortionsAdministrativeTax ?? this.mountPortionsAdministrativeTax,
      mountLiquidationPortions:
          mountLiquidationPortions ?? this.mountLiquidationPortions,
      mountLiquidationPortionPaymentForms:
          mountLiquidationPortionPaymentForms ??
          this.mountLiquidationPortionPaymentForms,
      mountRetroactivePosition:
          mountRetroactivePosition ?? this.mountRetroactivePosition,
      mountEnterprises: mountEnterprises ?? this.mountEnterprises,
      mountUnitGroups: mountUnitGroups ?? this.mountUnitGroups,
      mountControlDocuments:
          mountControlDocuments ?? this.mountControlDocuments,
      mountIncomeExpenseCenters:
          mountIncomeExpenseCenters ?? this.mountIncomeExpenseCenters,
      mountFinancialClassifications:
          mountFinancialClassifications ?? this.mountFinancialClassifications,
      mountFinancialClassificationIncomeExpenseCenters:
          mountFinancialClassificationIncomeExpenseCenters ??
          this.mountFinancialClassificationIncomeExpenseCenters,
      mountComparisonPeriod:
          mountComparisonPeriod ?? this.mountComparisonPeriod,
      mountCalculatedTotals:
          mountCalculatedTotals ?? this.mountCalculatedTotals,
    );
  }

  Map<String, dynamic> toBody() => {
    "enterpriseCodes": enterpriseCodes,
    "financialTitleTypes": financialTitleTypes.map((e) => e.value).toList(),
    "situations": situations.map((e) => e.value).toList(),
    "periodType": periodType.value,
    "period": {
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
    },
    if (comparisonStartDate != null && comparisonEndDate != null)
      "comparisonPeriod": {
        "startDate": comparisonStartDate!.toIso8601String(),
        "endDate": comparisonEndDate!.toIso8601String(),
      },
    if (positionDate != null) "positionDate": positionDate!.toIso8601String(),
    if (documentNumbers != null && documentNumbers!.isNotEmpty)
      "documentNumbers": documentNumbers,
    if (documentTypeCodes != null && documentTypeCodes!.isNotEmpty)
      "documentTypeCodes": documentTypeCodes,
    if (treasuryAccountCodes != null && treasuryAccountCodes!.isNotEmpty)
      "treasuryAccountCodes": treasuryAccountCodes,
    if (cadasterTypes != null && cadasterTypes!.isNotEmpty)
      "cadasterTypes": cadasterTypes!.map((e) => e.value).toList(),
    if (cadasterCodes != null && cadasterCodes!.isNotEmpty)
      "cadasterCodes": cadasterCodes,
    if (financialClassificationCodes != null &&
        financialClassificationCodes!.isNotEmpty)
      "financialClassificationCodes": financialClassificationCodes,
    "excludeFinancialClassifications": excludeFinancialClassifications,
    if (periodGrouping != null) "periodGrouping": periodGrouping!.value,
    if (groupByEnterprise) "groupByEnterprise": true,
    "mountPortionPayments": mountPortionPayments,
    "mountPortionsAdministrativeTax": mountPortionsAdministrativeTax,
    "mountLiquidationPortions": mountLiquidationPortions,
    "mountLiquidationPortionPaymentForms": mountLiquidationPortionPaymentForms,
    "mountRetroactivePosition": mountRetroactivePosition,
    "mountEnterprises": mountEnterprises,
    "mountUnitGroups": mountUnitGroups,
    "mountControlDocuments": mountControlDocuments,
    "mountIncomeExpenseCenters": mountIncomeExpenseCenters,
    "mountFinancialClassifications": mountFinancialClassifications,
    "mountFinancialClassificationIncomeExpenseCenters":
        mountFinancialClassificationIncomeExpenseCenters,
    "mountComparisonPeriod": mountComparisonPeriod,
    "mountCalculatedTotals": mountCalculatedTotals,
  };
}

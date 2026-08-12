import 'package:equatable/equatable.dart';

import 'financial_title_cadaster_type.dart';
import 'financial_title_period_grouping.dart';
import 'financial_title_period_params.dart';
import 'financial_title_period_type.dart';
import 'financial_title_situation.dart';
import 'financial_title_type.dart';

/// Complete request contract for `FinancialTitles/GetData`.
class SearchFinancialTitleDataParams extends Equatable {
  final List<int> enterpriseCodes;
  final List<FinancialTitleType> financialTitleTypes;
  final List<FinancialTitleSituation> situations;
  final FinancialTitlePeriodType periodType;
  final FinancialTitlePeriodParams period;
  final FinancialTitlePeriodParams? comparisonPeriod;
  final DateTime? positionDate;
  final List<String>? documentNumbers;
  final List<int>? documentTypeCodes;
  final List<int>? treasuryAccountCodes;
  final List<FinancialTitleCadasterType>? cadasterTypes;
  final List<int>? cadasterCodes;
  final List<int>? financialClassificationCodes;
  final bool excludeFinancialClassifications;
  final FinancialTitlePeriodGrouping? periodGrouping;
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
    required this.enterpriseCodes,
    required this.financialTitleTypes,
    required this.situations,
    required this.periodType,
    required this.period,
    this.comparisonPeriod,
    this.positionDate,
    this.documentNumbers,
    this.documentTypeCodes,
    this.treasuryAccountCodes,
    this.cadasterTypes,
    this.cadasterCodes,
    this.financialClassificationCodes,
    this.excludeFinancialClassifications = false,
    this.periodGrouping,
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
    this.mountCalculatedTotals = false,
  });

  @override
  List<Object?> get props => [
        enterpriseCodes,
        financialTitleTypes,
        situations,
        periodType,
        period,
        comparisonPeriod,
        positionDate,
        documentNumbers,
        documentTypeCodes,
        treasuryAccountCodes,
        cadasterTypes,
        cadasterCodes,
        financialClassificationCodes,
        excludeFinancialClassifications,
        periodGrouping,
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
}

import 'package:equatable/equatable.dart';

import '../request/search_financial_title_data_params.dart';
import 'financial_title_administrative_tax_entity.dart';
import 'financial_title_calculated_totals_entity.dart';
import 'financial_title_classification_entity.dart';
import 'financial_title_classification_income_expense_center_entity.dart';
import 'financial_title_control_document_entity.dart';
import 'financial_title_data_entity.dart';
import 'financial_title_enterprise_entity.dart';
import 'financial_title_income_expense_center_entity.dart';
import 'financial_title_liquidation_payment_form_entity.dart';
import 'financial_title_liquidation_portion_entity.dart';
import 'financial_title_portion_payment_entity.dart';
import 'financial_title_retroactive_position_entity.dart';
import 'financial_title_unit_group_entity.dart';

class FinancialTitleDataResponseEntity extends Equatable {
  final SearchFinancialTitleDataParams searchParameters;
  final List<FinancialTitleDataEntity> financialTitlePortions;
  final List<FinancialTitlePortionPaymentEntity>? portionPayments;
  final List<FinancialTitleAdministrativeTaxEntity>? portionsAdministrativeTax;
  final List<FinancialTitleLiquidationPortionEntity>? liquidationPortions;
  final List<FinancialTitleLiquidationPaymentFormEntity>?
      liquidationPortionPaymentForms;
  final List<FinancialTitleRetroactivePositionEntity>? retroactivePositions;
  final List<FinancialTitleEnterpriseEntity>? enterprises;
  final List<FinancialTitleUnitGroupEntity>? unitGroups;
  final List<FinancialTitleControlDocumentEntity>? controlDocuments;
  final List<FinancialTitleIncomeExpenseCenterEntity>? incomeExpenseCenters;
  final List<FinancialTitleClassificationEntity>? financialClassifications;
  final List<FinancialTitleClassificationIncomeExpenseCenterEntity>?
      financialClassificationIncomeExpenseCenters;
  final List<FinancialTitleDataEntity>? comparisonFinancialTitlePortions;
  final FinancialTitleCalculatedTotalsEntity? calculatedTotals;

  const FinancialTitleDataResponseEntity({
    required this.searchParameters,
    required this.financialTitlePortions,
    required this.portionPayments,
    required this.portionsAdministrativeTax,
    required this.liquidationPortions,
    required this.liquidationPortionPaymentForms,
    required this.retroactivePositions,
    required this.enterprises,
    required this.unitGroups,
    required this.controlDocuments,
    required this.incomeExpenseCenters,
    required this.financialClassifications,
    required this.financialClassificationIncomeExpenseCenters,
    required this.comparisonFinancialTitlePortions,
    required this.calculatedTotals,
  });

  @override
  List<Object?> get props => [
        searchParameters,
        financialTitlePortions,
        portionPayments,
        portionsAdministrativeTax,
        liquidationPortions,
        liquidationPortionPaymentForms,
        retroactivePositions,
        enterprises,
        unitGroups,
        controlDocuments,
        incomeExpenseCenters,
        financialClassifications,
        financialClassificationIncomeExpenseCenters,
        comparisonFinancialTitlePortions,
        calculatedTotals,
      ];
}

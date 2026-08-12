import 'package:celta_dash/domain/entities/entities.dart';

import '../request/search_financial_title_data_model.dart';
import 'financial_title_portion_payment_model.dart';
import 'financial_title_administrative_tax_model.dart';
import 'financial_title_liquidation_portion_model.dart';
import 'financial_title_liquidation_payment_form_model.dart';
import 'financial_title_retroactive_position_model.dart';
import 'financial_title_enterprise_model.dart';
import 'financial_title_unit_group_model.dart';
import 'financial_title_control_document_model.dart';
import 'financial_title_income_expense_center_model.dart';
import 'financial_title_classification_model.dart';
import 'financial_title_classification_income_expense_center_model.dart';
import 'financial_title_calculated_totals_model.dart';
import 'financial_title_data_model.dart';

class FinancialTitleDataResponseModel extends FinancialTitleDataResponseEntity {
  const FinancialTitleDataResponseModel({
    required super.searchParameters,
    required super.financialTitlePortions,
    required super.portionPayments,
    required super.portionsAdministrativeTax,
    required super.liquidationPortions,
    required super.liquidationPortionPaymentForms,
    required super.retroactivePositions,
    required super.enterprises,
    required super.unitGroups,
    required super.controlDocuments,
    required super.incomeExpenseCenters,
    required super.financialClassifications,
    required super.financialClassificationIncomeExpenseCenters,
    required super.comparisonFinancialTitlePortions,
    required super.calculatedTotals,
  });

  factory FinancialTitleDataResponseModel.fromJson(Map json) =>
      FinancialTitleDataResponseModel(
        searchParameters: SearchFinancialTitleDataModel.fromJson(
            json['searchParameters'] as Map),
        financialTitlePortions: (json['financialTitlePortions'] as List)
            .map((item) => FinancialTitleDataModel.fromJson(item as Map))
            .toList(),
        portionPayments: (json['portionPayments'] as List?)
            ?.map((item) =>
                FinancialTitlePortionPaymentModel.fromJson(item as Map))
            .toList(),
        portionsAdministrativeTax: (json['portionsAdministrativeTax'] as List?)
            ?.map((item) =>
                FinancialTitleAdministrativeTaxModel.fromJson(item as Map))
            .toList(),
        liquidationPortions: (json['liquidationPortions'] as List?)
            ?.map((item) =>
                FinancialTitleLiquidationPortionModel.fromJson(item as Map))
            .toList(),
        liquidationPortionPaymentForms: (json['liquidationPortionPaymentForms']
                as List?)
            ?.map((item) =>
                FinancialTitleLiquidationPaymentFormModel.fromJson(item as Map))
            .toList(),
        retroactivePositions: (json['retroactivePositions'] as List?)
            ?.map((item) =>
                FinancialTitleRetroactivePositionModel.fromJson(item as Map))
            .toList(),
        enterprises: (json['enterprises'] as List?)
            ?.map((item) => FinancialTitleEnterpriseModel.fromJson(item as Map))
            .toList(),
        unitGroups: (json['unitGroups'] as List?)
            ?.map((item) => FinancialTitleUnitGroupModel.fromJson(item as Map))
            .toList(),
        controlDocuments: (json['controlDocuments'] as List?)
            ?.map((item) =>
                FinancialTitleControlDocumentModel.fromJson(item as Map))
            .toList(),
        incomeExpenseCenters: (json['incomeExpenseCenters'] as List?)
            ?.map((item) =>
                FinancialTitleIncomeExpenseCenterModel.fromJson(item as Map))
            .toList(),
        financialClassifications: (json['financialClassifications'] as List?)
            ?.map((item) =>
                FinancialTitleClassificationModel.fromJson(item as Map))
            .toList(),
        financialClassificationIncomeExpenseCenters:
            (json['financialClassificationIncomeExpenseCenters'] as List?)
                ?.map((item) =>
                    FinancialTitleClassificationIncomeExpenseCenterModel
                        .fromJson(item as Map))
                .toList(),
        comparisonFinancialTitlePortions:
            (json['comparisonFinancialTitlePortions'] as List?)
                ?.map((item) => FinancialTitleDataModel.fromJson(item as Map))
                .toList(),
        calculatedTotals: json['calculatedTotals'] == null
            ? null
            : FinancialTitleCalculatedTotalsModel.fromJson(
                json['calculatedTotals'] as Map),
      );

  factory FinancialTitleDataResponseModel.fromEntity(
    FinancialTitleDataResponseEntity entity,
  ) =>
      FinancialTitleDataResponseModel(
        searchParameters:
            SearchFinancialTitleDataModel.fromEntity(entity.searchParameters),
        financialTitlePortions: entity.financialTitlePortions
            .map(FinancialTitleDataModel.fromEntity)
            .toList(),
        portionPayments: entity.portionPayments
            ?.map(FinancialTitlePortionPaymentModel.fromEntity)
            .toList(),
        portionsAdministrativeTax: entity.portionsAdministrativeTax
            ?.map(FinancialTitleAdministrativeTaxModel.fromEntity)
            .toList(),
        liquidationPortions: entity.liquidationPortions
            ?.map(FinancialTitleLiquidationPortionModel.fromEntity)
            .toList(),
        liquidationPortionPaymentForms: entity.liquidationPortionPaymentForms
            ?.map(FinancialTitleLiquidationPaymentFormModel.fromEntity)
            .toList(),
        retroactivePositions: entity.retroactivePositions
            ?.map(FinancialTitleRetroactivePositionModel.fromEntity)
            .toList(),
        enterprises: entity.enterprises
            ?.map(FinancialTitleEnterpriseModel.fromEntity)
            .toList(),
        unitGroups: entity.unitGroups
            ?.map(FinancialTitleUnitGroupModel.fromEntity)
            .toList(),
        controlDocuments: entity.controlDocuments
            ?.map(FinancialTitleControlDocumentModel.fromEntity)
            .toList(),
        incomeExpenseCenters: entity.incomeExpenseCenters
            ?.map(FinancialTitleIncomeExpenseCenterModel.fromEntity)
            .toList(),
        financialClassifications: entity.financialClassifications
            ?.map(FinancialTitleClassificationModel.fromEntity)
            .toList(),
        financialClassificationIncomeExpenseCenters: entity
            .financialClassificationIncomeExpenseCenters
            ?.map(
                FinancialTitleClassificationIncomeExpenseCenterModel.fromEntity)
            .toList(),
        comparisonFinancialTitlePortions: entity
            .comparisonFinancialTitlePortions
            ?.map(FinancialTitleDataModel.fromEntity)
            .toList(),
        calculatedTotals: entity.calculatedTotals == null
            ? null
            : FinancialTitleCalculatedTotalsModel.fromEntity(
                entity.calculatedTotals!),
      );

  Map<String, dynamic> toJson() => {
        'searchParameters':
            SearchFinancialTitleDataModel.fromEntity(searchParameters).toJson(),
        'financialTitlePortions': financialTitlePortions
            .map((item) => FinancialTitleDataModel.fromEntity(item).toJson())
            .toList(),
        'portionPayments': portionPayments
            ?.map((item) =>
                FinancialTitlePortionPaymentModel.fromEntity(item).toJson())
            .toList(),
        'portionsAdministrativeTax': portionsAdministrativeTax
            ?.map((item) =>
                FinancialTitleAdministrativeTaxModel.fromEntity(item).toJson())
            .toList(),
        'liquidationPortions': liquidationPortions
            ?.map((item) =>
                FinancialTitleLiquidationPortionModel.fromEntity(item).toJson())
            .toList(),
        'liquidationPortionPaymentForms': liquidationPortionPaymentForms
            ?.map((item) =>
                FinancialTitleLiquidationPaymentFormModel.fromEntity(item)
                    .toJson())
            .toList(),
        'retroactivePositions': retroactivePositions
            ?.map((item) =>
                FinancialTitleRetroactivePositionModel.fromEntity(item)
                    .toJson())
            .toList(),
        'enterprises': enterprises
            ?.map((item) =>
                FinancialTitleEnterpriseModel.fromEntity(item).toJson())
            .toList(),
        'unitGroups': unitGroups
            ?.map((item) =>
                FinancialTitleUnitGroupModel.fromEntity(item).toJson())
            .toList(),
        'controlDocuments': controlDocuments
            ?.map((item) =>
                FinancialTitleControlDocumentModel.fromEntity(item).toJson())
            .toList(),
        'incomeExpenseCenters': incomeExpenseCenters
            ?.map((item) =>
                FinancialTitleIncomeExpenseCenterModel.fromEntity(item)
                    .toJson())
            .toList(),
        'financialClassifications': financialClassifications
            ?.map((item) =>
                FinancialTitleClassificationModel.fromEntity(item).toJson())
            .toList(),
        'financialClassificationIncomeExpenseCenters':
            financialClassificationIncomeExpenseCenters
                ?.map((item) =>
                    FinancialTitleClassificationIncomeExpenseCenterModel
                            .fromEntity(item)
                        .toJson())
                .toList(),
        'comparisonFinancialTitlePortions': comparisonFinancialTitlePortions
            ?.map((item) => FinancialTitleDataModel.fromEntity(item).toJson())
            .toList(),
        'calculatedTotals': calculatedTotals == null
            ? null
            : FinancialTitleCalculatedTotalsModel.fromEntity(calculatedTotals!)
                .toJson(),
      };

  FinancialTitleDataResponseEntity toEntity() =>
      FinancialTitleDataResponseEntity(
        searchParameters: searchParameters,
        financialTitlePortions: financialTitlePortions,
        portionPayments: portionPayments,
        portionsAdministrativeTax: portionsAdministrativeTax,
        liquidationPortions: liquidationPortions,
        liquidationPortionPaymentForms: liquidationPortionPaymentForms,
        retroactivePositions: retroactivePositions,
        enterprises: enterprises,
        unitGroups: unitGroups,
        controlDocuments: controlDocuments,
        incomeExpenseCenters: incomeExpenseCenters,
        financialClassifications: financialClassifications,
        financialClassificationIncomeExpenseCenters:
            financialClassificationIncomeExpenseCenters,
        comparisonFinancialTitlePortions: comparisonFinancialTitlePortions,
        calculatedTotals: calculatedTotals,
      );
}

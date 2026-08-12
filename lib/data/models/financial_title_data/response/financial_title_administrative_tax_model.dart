import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleAdministrativeTaxModel
    extends FinancialTitleAdministrativeTaxEntity {
  const FinancialTitleAdministrativeTaxModel({
    required super.financialTitlePortionCode,
    required super.saleDateOfBilling,
    required super.saleDocumentNumber,
    required super.administrativeTaxValue,
    required super.operationalTaxValue,
    required super.value,
    required super.liquidValue,
    required super.cadasterTypeName,
    required super.enterpriseCode,
    required super.portionQuantity,
  });

  factory FinancialTitleAdministrativeTaxModel.fromJson(Map json) =>
      FinancialTitleAdministrativeTaxModel(
        financialTitlePortionCode: json['financialTitlePortionCode'] as int?,
        saleDateOfBilling: json['saleDateOfBilling'] == null
            ? null
            : DateTime.parse(json['saleDateOfBilling'] as String),
        saleDocumentNumber: json['saleDocumentNumber'] as String?,
        administrativeTaxValue: json['administrativeTaxValue'] as num?,
        operationalTaxValue: json['operationalTaxValue'] as num?,
        value: json['value'] as num?,
        liquidValue: json['liquidValue'] as num?,
        cadasterTypeName: json['cadasterTypeName'] as String?,
        enterpriseCode: json['enterpriseCode'] as int?,
        portionQuantity: json['portionQuantity'] as int?,
      );

  factory FinancialTitleAdministrativeTaxModel.fromEntity(
          FinancialTitleAdministrativeTaxEntity entity) =>
      FinancialTitleAdministrativeTaxModel(
        financialTitlePortionCode: entity.financialTitlePortionCode,
        saleDateOfBilling: entity.saleDateOfBilling,
        saleDocumentNumber: entity.saleDocumentNumber,
        administrativeTaxValue: entity.administrativeTaxValue,
        operationalTaxValue: entity.operationalTaxValue,
        value: entity.value,
        liquidValue: entity.liquidValue,
        cadasterTypeName: entity.cadasterTypeName,
        enterpriseCode: entity.enterpriseCode,
        portionQuantity: entity.portionQuantity,
      );

  Map<String, dynamic> toJson() => {
        'financialTitlePortionCode': financialTitlePortionCode,
        'saleDateOfBilling': saleDateOfBilling?.toIso8601String(),
        'saleDocumentNumber': saleDocumentNumber,
        'administrativeTaxValue': administrativeTaxValue,
        'operationalTaxValue': operationalTaxValue,
        'value': value,
        'liquidValue': liquidValue,
        'cadasterTypeName': cadasterTypeName,
        'enterpriseCode': enterpriseCode,
        'portionQuantity': portionQuantity,
      };

  FinancialTitleAdministrativeTaxEntity toEntity() =>
      FinancialTitleAdministrativeTaxEntity(
        financialTitlePortionCode: financialTitlePortionCode,
        saleDateOfBilling: saleDateOfBilling,
        saleDocumentNumber: saleDocumentNumber,
        administrativeTaxValue: administrativeTaxValue,
        operationalTaxValue: operationalTaxValue,
        value: value,
        liquidValue: liquidValue,
        cadasterTypeName: cadasterTypeName,
        enterpriseCode: enterpriseCode,
        portionQuantity: portionQuantity,
      );
}

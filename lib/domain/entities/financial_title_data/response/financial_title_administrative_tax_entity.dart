import 'package:equatable/equatable.dart';

/// Administrative-tax detail returned by Commerce API.
class FinancialTitleAdministrativeTaxEntity extends Equatable {
  final int? financialTitlePortionCode;
  final DateTime? saleDateOfBilling;
  final String? saleDocumentNumber;
  final num? administrativeTaxValue;
  final num? operationalTaxValue;
  final num? value;
  final num? liquidValue;
  final String? cadasterTypeName;
  final int? enterpriseCode;
  final int? portionQuantity;

  const FinancialTitleAdministrativeTaxEntity({
    required this.financialTitlePortionCode,
    required this.saleDateOfBilling,
    required this.saleDocumentNumber,
    required this.administrativeTaxValue,
    required this.operationalTaxValue,
    required this.value,
    required this.liquidValue,
    required this.cadasterTypeName,
    required this.enterpriseCode,
    required this.portionQuantity,
  });

  @override
  List<Object?> get props => [
        financialTitlePortionCode,
        saleDateOfBilling,
        saleDocumentNumber,
        administrativeTaxValue,
        operationalTaxValue,
        value,
        liquidValue,
        cadasterTypeName,
        enterpriseCode,
        portionQuantity,
      ];
}

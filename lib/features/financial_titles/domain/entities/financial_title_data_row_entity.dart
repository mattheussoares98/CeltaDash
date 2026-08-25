// lib/features/financial_titles/domain/entities/financial_title_data_row_entity.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class FinancialTitleDataRowEntity extends Equatable {
  final int? financialTitleCode;
  final int? financialTitlePortionCode;
  final int? enterpriseCode;
  final int? portionNumber;
  final int? portionQuantity;
  final String? documentNumber;
  final int? documentTypeCode;
  final FinancialTitleType? financialTitleType;
  final FinancialTitleSituation? situation;
  final bool? isForecast;
  final bool? isBlocked;
  final DateTime? emissionDate;
  final DateTime? generationDate;
  final DateTime? deliveryDate;
  final DateTime? expirationDate;
  final DateTime? anticipatedPaymentDate;
  final DateTime? periodDate;
  final DateTime? date;
  final int? year;
  final int? month;
  final num? grossValue;
  final num? liquidValue;
  final num? openValue;
  final num? settledValue;
  final num? increaseValue;
  final num? discountValue;
  final num? receiveGrossValue;
  final num? payGrossValue;
  final num? grossBalanceValue;
  final num? receiveLiquidValue;
  final num? payLiquidValue;
  final num? liquidBalanceValue;
  final num? receiveOpenValue;
  final num? payOpenValue;
  final num? openBalanceValue;
  final num? receiveSettledValue;
  final num? paySettledValue;
  final num? settledBalanceValue;
  final num? receiveIncreaseValue;
  final num? payIncreaseValue;
  final num? increaseBalanceValue;
  final num? receiveDiscountValue;
  final num? payDiscountValue;
  final num? discountBalanceValue;
  final FinancialTitleCadasterType? cadasterType;
  final int? cadasterCode;
  final int? treasuryAccountCode;
  final int? unitGroupCode;

  const FinancialTitleDataRowEntity({
    this.financialTitleCode,
    this.financialTitlePortionCode,
    this.enterpriseCode,
    this.portionNumber,
    this.portionQuantity,
    this.documentNumber,
    this.documentTypeCode,
    this.financialTitleType,
    this.situation,
    this.isForecast,
    this.isBlocked,
    this.emissionDate,
    this.generationDate,
    this.deliveryDate,
    this.expirationDate,
    this.anticipatedPaymentDate,
    this.periodDate,
    this.date,
    this.year,
    this.month,
    this.grossValue,
    this.liquidValue,
    this.openValue,
    this.settledValue,
    this.increaseValue,
    this.discountValue,
    this.receiveGrossValue,
    this.payGrossValue,
    this.grossBalanceValue,
    this.receiveLiquidValue,
    this.payLiquidValue,
    this.liquidBalanceValue,
    this.receiveOpenValue,
    this.payOpenValue,
    this.openBalanceValue,
    this.receiveSettledValue,
    this.paySettledValue,
    this.settledBalanceValue,
    this.receiveIncreaseValue,
    this.payIncreaseValue,
    this.increaseBalanceValue,
    this.receiveDiscountValue,
    this.payDiscountValue,
    this.discountBalanceValue,
    this.cadasterType,
    this.cadasterCode,
    this.treasuryAccountCode,
    this.unitGroupCode,
  });

  @override
  List<Object?> get props => [
    financialTitleCode,
    financialTitlePortionCode,
    enterpriseCode,
    portionNumber,
    portionQuantity,
    documentNumber,
    documentTypeCode,
    financialTitleType,
    situation,
    isForecast,
    isBlocked,
    emissionDate,
    generationDate,
    deliveryDate,
    expirationDate,
    anticipatedPaymentDate,
    periodDate,
    date,
    year,
    month,
    grossValue,
    liquidValue,
    openValue,
    settledValue,
    increaseValue,
    discountValue,
    receiveGrossValue,
    payGrossValue,
    grossBalanceValue,
    receiveLiquidValue,
    payLiquidValue,
    liquidBalanceValue,
    receiveOpenValue,
    payOpenValue,
    openBalanceValue,
    receiveSettledValue,
    paySettledValue,
    settledBalanceValue,
    receiveIncreaseValue,
    payIncreaseValue,
    increaseBalanceValue,
    receiveDiscountValue,
    payDiscountValue,
    discountBalanceValue,
    cadasterType,
    cadasterCode,
    treasuryAccountCode,
    unitGroupCode,
  ];
}

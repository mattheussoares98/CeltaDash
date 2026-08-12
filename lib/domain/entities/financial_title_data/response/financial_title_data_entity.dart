import 'package:equatable/equatable.dart';

import '../request/financial_title_cadaster_type.dart';
import '../request/financial_title_situation.dart';
import '../request/financial_title_type.dart';

class FinancialTitleDataEntity extends Equatable {
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

  const FinancialTitleDataEntity({
    required this.financialTitleCode,
    required this.financialTitlePortionCode,
    required this.enterpriseCode,
    required this.portionNumber,
    required this.portionQuantity,
    required this.documentNumber,
    required this.documentTypeCode,
    required this.financialTitleType,
    required this.situation,
    required this.isForecast,
    required this.isBlocked,
    required this.emissionDate,
    required this.generationDate,
    required this.deliveryDate,
    required this.expirationDate,
    required this.anticipatedPaymentDate,
    required this.periodDate,
    required this.date,
    required this.year,
    required this.month,
    required this.grossValue,
    required this.liquidValue,
    required this.openValue,
    required this.settledValue,
    required this.increaseValue,
    required this.discountValue,
    required this.receiveGrossValue,
    required this.payGrossValue,
    required this.grossBalanceValue,
    required this.receiveLiquidValue,
    required this.payLiquidValue,
    required this.liquidBalanceValue,
    required this.receiveOpenValue,
    required this.payOpenValue,
    required this.openBalanceValue,
    required this.receiveSettledValue,
    required this.paySettledValue,
    required this.settledBalanceValue,
    required this.receiveIncreaseValue,
    required this.payIncreaseValue,
    required this.increaseBalanceValue,
    required this.receiveDiscountValue,
    required this.payDiscountValue,
    required this.discountBalanceValue,
    required this.cadasterType,
    required this.cadasterCode,
    required this.treasuryAccountCode,
    required this.unitGroupCode,
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

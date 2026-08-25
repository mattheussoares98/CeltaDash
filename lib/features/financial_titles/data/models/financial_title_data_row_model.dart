// lib/features/financial_titles/data/models/financial_title_data_row_model.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class FinancialTitleDataRowModel extends Equatable {
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

  const FinancialTitleDataRowModel({
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

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  factory FinancialTitleDataRowModel.fromJson(Map json) {
    return FinancialTitleDataRowModel(
      financialTitleCode:
          json['FinancialTitleCode'] ?? json['financialTitleCode'],
      financialTitlePortionCode:
          json['FinancialTitlePortionCode'] ?? json['financialTitlePortionCode'],
      enterpriseCode: json['EnterpriseCode'] ?? json['enterpriseCode'],
      portionNumber: json['PortionNumber'] ?? json['portionNumber'],
      portionQuantity: json['PortionQuantity'] ?? json['portionQuantity'],
      documentNumber: json['DocumentNumber'] ?? json['documentNumber'],
      documentTypeCode: json['DocumentTypeCode'] ?? json['documentTypeCode'],
      financialTitleType: FinancialTitleType.fromValue(
        json['FinancialTitleType'] ?? json['financialTitleType'],
      ),
      situation: FinancialTitleSituation.fromValue(
        json['Situation'] ?? json['situation'],
      ),
      isForecast: json['IsForecast'] ?? json['isForecast'],
      isBlocked: json['IsBlocked'] ?? json['isBlocked'],
      emissionDate: _parseDate(json['EmissionDate'] ?? json['emissionDate']),
      generationDate: _parseDate(
        json['GenerationDate'] ?? json['generationDate'],
      ),
      deliveryDate: _parseDate(json['DeliveryDate'] ?? json['deliveryDate']),
      expirationDate: _parseDate(
        json['ExpirationDate'] ?? json['expirationDate'],
      ),
      anticipatedPaymentDate: _parseDate(
        json['AnticipatedPaymentDate'] ?? json['anticipatedPaymentDate'],
      ),
      periodDate: _parseDate(json['PeriodDate'] ?? json['periodDate']),
      date: _parseDate(json['Date'] ?? json['date']),
      year: json['Year'] ?? json['year'],
      month: json['Month'] ?? json['month'],
      grossValue: json['GrossValue'] ?? json['grossValue'],
      liquidValue: json['LiquidValue'] ?? json['liquidValue'],
      openValue: json['OpenValue'] ?? json['openValue'],
      settledValue: json['SettledValue'] ?? json['settledValue'],
      increaseValue: json['IncreaseValue'] ?? json['increaseValue'],
      discountValue: json['DiscountValue'] ?? json['discountValue'],
      receiveGrossValue:
          json['ReceiveGrossValue'] ?? json['receiveGrossValue'],
      payGrossValue: json['PayGrossValue'] ?? json['payGrossValue'],
      grossBalanceValue:
          json['GrossBalanceValue'] ?? json['grossBalanceValue'],
      receiveLiquidValue:
          json['ReceiveLiquidValue'] ?? json['receiveLiquidValue'],
      payLiquidValue: json['PayLiquidValue'] ?? json['payLiquidValue'],
      liquidBalanceValue:
          json['LiquidBalanceValue'] ?? json['liquidBalanceValue'],
      receiveOpenValue: json['ReceiveOpenValue'] ?? json['receiveOpenValue'],
      payOpenValue: json['PayOpenValue'] ?? json['payOpenValue'],
      openBalanceValue: json['OpenBalanceValue'] ?? json['openBalanceValue'],
      receiveSettledValue:
          json['ReceiveSettledValue'] ?? json['receiveSettledValue'],
      paySettledValue: json['PaySettledValue'] ?? json['paySettledValue'],
      settledBalanceValue:
          json['SettledBalanceValue'] ?? json['settledBalanceValue'],
      receiveIncreaseValue:
          json['ReceiveIncreaseValue'] ?? json['receiveIncreaseValue'],
      payIncreaseValue: json['PayIncreaseValue'] ?? json['payIncreaseValue'],
      increaseBalanceValue:
          json['IncreaseBalanceValue'] ?? json['increaseBalanceValue'],
      receiveDiscountValue:
          json['ReceiveDiscountValue'] ?? json['receiveDiscountValue'],
      payDiscountValue: json['PayDiscountValue'] ?? json['payDiscountValue'],
      discountBalanceValue:
          json['DiscountBalanceValue'] ?? json['discountBalanceValue'],
      cadasterType: FinancialTitleCadasterType.fromValue(
        json['CadasterType'] ?? json['cadasterType'],
      ),
      cadasterCode: json['CadasterCode'] ?? json['cadasterCode'],
      treasuryAccountCode:
          json['TreasuryAccountCode'] ?? json['treasuryAccountCode'],
      unitGroupCode: json['UnitGroupCode'] ?? json['unitGroupCode'],
    );
  }

  factory FinancialTitleDataRowModel.fromEntity(
    FinancialTitleDataRowEntity entity,
  ) {
    return FinancialTitleDataRowModel(
      financialTitleCode: entity.financialTitleCode,
      financialTitlePortionCode: entity.financialTitlePortionCode,
      enterpriseCode: entity.enterpriseCode,
      portionNumber: entity.portionNumber,
      portionQuantity: entity.portionQuantity,
      documentNumber: entity.documentNumber,
      documentTypeCode: entity.documentTypeCode,
      financialTitleType: entity.financialTitleType,
      situation: entity.situation,
      isForecast: entity.isForecast,
      isBlocked: entity.isBlocked,
      emissionDate: entity.emissionDate,
      generationDate: entity.generationDate,
      deliveryDate: entity.deliveryDate,
      expirationDate: entity.expirationDate,
      anticipatedPaymentDate: entity.anticipatedPaymentDate,
      periodDate: entity.periodDate,
      date: entity.date,
      year: entity.year,
      month: entity.month,
      grossValue: entity.grossValue,
      liquidValue: entity.liquidValue,
      openValue: entity.openValue,
      settledValue: entity.settledValue,
      increaseValue: entity.increaseValue,
      discountValue: entity.discountValue,
      receiveGrossValue: entity.receiveGrossValue,
      payGrossValue: entity.payGrossValue,
      grossBalanceValue: entity.grossBalanceValue,
      receiveLiquidValue: entity.receiveLiquidValue,
      payLiquidValue: entity.payLiquidValue,
      liquidBalanceValue: entity.liquidBalanceValue,
      receiveOpenValue: entity.receiveOpenValue,
      payOpenValue: entity.payOpenValue,
      openBalanceValue: entity.openBalanceValue,
      receiveSettledValue: entity.receiveSettledValue,
      paySettledValue: entity.paySettledValue,
      settledBalanceValue: entity.settledBalanceValue,
      receiveIncreaseValue: entity.receiveIncreaseValue,
      payIncreaseValue: entity.payIncreaseValue,
      increaseBalanceValue: entity.increaseBalanceValue,
      receiveDiscountValue: entity.receiveDiscountValue,
      payDiscountValue: entity.payDiscountValue,
      discountBalanceValue: entity.discountBalanceValue,
      cadasterType: entity.cadasterType,
      cadasterCode: entity.cadasterCode,
      treasuryAccountCode: entity.treasuryAccountCode,
      unitGroupCode: entity.unitGroupCode,
    );
  }

  FinancialTitleDataRowEntity toEntity() {
    return FinancialTitleDataRowEntity(
      financialTitleCode: financialTitleCode,
      financialTitlePortionCode: financialTitlePortionCode,
      enterpriseCode: enterpriseCode,
      portionNumber: portionNumber,
      portionQuantity: portionQuantity,
      documentNumber: documentNumber,
      documentTypeCode: documentTypeCode,
      financialTitleType: financialTitleType,
      situation: situation,
      isForecast: isForecast,
      isBlocked: isBlocked,
      emissionDate: emissionDate,
      generationDate: generationDate,
      deliveryDate: deliveryDate,
      expirationDate: expirationDate,
      anticipatedPaymentDate: anticipatedPaymentDate,
      periodDate: periodDate,
      date: date,
      year: year,
      month: month,
      grossValue: grossValue,
      liquidValue: liquidValue,
      openValue: openValue,
      settledValue: settledValue,
      increaseValue: increaseValue,
      discountValue: discountValue,
      receiveGrossValue: receiveGrossValue,
      payGrossValue: payGrossValue,
      grossBalanceValue: grossBalanceValue,
      receiveLiquidValue: receiveLiquidValue,
      payLiquidValue: payLiquidValue,
      liquidBalanceValue: liquidBalanceValue,
      receiveOpenValue: receiveOpenValue,
      payOpenValue: payOpenValue,
      openBalanceValue: openBalanceValue,
      receiveSettledValue: receiveSettledValue,
      paySettledValue: paySettledValue,
      settledBalanceValue: settledBalanceValue,
      receiveIncreaseValue: receiveIncreaseValue,
      payIncreaseValue: payIncreaseValue,
      increaseBalanceValue: increaseBalanceValue,
      receiveDiscountValue: receiveDiscountValue,
      payDiscountValue: payDiscountValue,
      discountBalanceValue: discountBalanceValue,
      cadasterType: cadasterType,
      cadasterCode: cadasterCode,
      treasuryAccountCode: treasuryAccountCode,
      unitGroupCode: unitGroupCode,
    );
  }

  Map toJson() => {
    'FinancialTitleCode': financialTitleCode,
    'FinancialTitlePortionCode': financialTitlePortionCode,
    'EnterpriseCode': enterpriseCode,
    'PortionNumber': portionNumber,
    'PortionQuantity': portionQuantity,
    'DocumentNumber': documentNumber,
    'DocumentTypeCode': documentTypeCode,
    'FinancialTitleType': financialTitleType?.value,
    'Situation': situation?.value,
    'IsForecast': isForecast,
    'IsBlocked': isBlocked,
    'EmissionDate': emissionDate?.toIso8601String(),
    'GenerationDate': generationDate?.toIso8601String(),
    'DeliveryDate': deliveryDate?.toIso8601String(),
    'ExpirationDate': expirationDate?.toIso8601String(),
    'AnticipatedPaymentDate': anticipatedPaymentDate?.toIso8601String(),
    'PeriodDate': periodDate?.toIso8601String(),
    'Date': date?.toIso8601String(),
    'Year': year,
    'Month': month,
    'GrossValue': grossValue,
    'LiquidValue': liquidValue,
    'OpenValue': openValue,
    'SettledValue': settledValue,
    'IncreaseValue': increaseValue,
    'DiscountValue': discountValue,
    'ReceiveGrossValue': receiveGrossValue,
    'PayGrossValue': payGrossValue,
    'GrossBalanceValue': grossBalanceValue,
    'ReceiveLiquidValue': receiveLiquidValue,
    'PayLiquidValue': payLiquidValue,
    'LiquidBalanceValue': liquidBalanceValue,
    'ReceiveOpenValue': receiveOpenValue,
    'PayOpenValue': payOpenValue,
    'OpenBalanceValue': openBalanceValue,
    'ReceiveSettledValue': receiveSettledValue,
    'PaySettledValue': paySettledValue,
    'SettledBalanceValue': settledBalanceValue,
    'ReceiveIncreaseValue': receiveIncreaseValue,
    'PayIncreaseValue': payIncreaseValue,
    'IncreaseBalanceValue': increaseBalanceValue,
    'ReceiveDiscountValue': receiveDiscountValue,
    'PayDiscountValue': payDiscountValue,
    'DiscountBalanceValue': discountBalanceValue,
    'CadasterType': cadasterType?.value,
    'CadasterCode': cadasterCode,
    'TreasuryAccountCode': treasuryAccountCode,
    'UnitGroupCode': unitGroupCode,
  };
}

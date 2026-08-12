import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitlePortionPaymentModel
    extends FinancialTitlePortionPaymentEntity {
  const FinancialTitlePortionPaymentModel({
    required super.financialTitlePortionCode,
    required super.paymentFormDescription,
    required super.value,
    required super.liquidationDate,
  });

  factory FinancialTitlePortionPaymentModel.fromJson(Map json) =>
      FinancialTitlePortionPaymentModel(
        financialTitlePortionCode: json['financialTitlePortionCode'] as int?,
        paymentFormDescription: json['paymentFormDescription'] as String?,
        value: json['value'] as num?,
        liquidationDate: json['liquidationDate'] == null
            ? null
            : DateTime.parse(json['liquidationDate'] as String),
      );

  factory FinancialTitlePortionPaymentModel.fromEntity(
          FinancialTitlePortionPaymentEntity entity) =>
      FinancialTitlePortionPaymentModel(
        financialTitlePortionCode: entity.financialTitlePortionCode,
        paymentFormDescription: entity.paymentFormDescription,
        value: entity.value,
        liquidationDate: entity.liquidationDate,
      );

  Map<String, dynamic> toJson() => {
        'financialTitlePortionCode': financialTitlePortionCode,
        'paymentFormDescription': paymentFormDescription,
        'value': value,
        'liquidationDate': liquidationDate?.toIso8601String(),
      };

  FinancialTitlePortionPaymentEntity toEntity() =>
      FinancialTitlePortionPaymentEntity(
        financialTitlePortionCode: financialTitlePortionCode,
        paymentFormDescription: paymentFormDescription,
        value: value,
        liquidationDate: liquidationDate,
      );
}

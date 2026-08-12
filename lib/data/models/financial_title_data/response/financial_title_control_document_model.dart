import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleControlDocumentModel
    extends FinancialTitleControlDocumentEntity {
  const FinancialTitleControlDocumentModel({
    required super.code,
    required super.controlCode,
    required super.value,
    required super.ourNumber,
    required super.financialTitlePortionCode,
  });

  factory FinancialTitleControlDocumentModel.fromJson(Map json) =>
      FinancialTitleControlDocumentModel(
        code: json['code'] as int?,
        controlCode: json['controlCode'] as String?,
        value: json['value'] as num?,
        ourNumber: json['ourNumber'] as String?,
        financialTitlePortionCode: json['financialTitlePortionCode'] as int?,
      );

  factory FinancialTitleControlDocumentModel.fromEntity(
          FinancialTitleControlDocumentEntity entity) =>
      FinancialTitleControlDocumentModel(
        code: entity.code,
        controlCode: entity.controlCode,
        value: entity.value,
        ourNumber: entity.ourNumber,
        financialTitlePortionCode: entity.financialTitlePortionCode,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'controlCode': controlCode,
        'value': value,
        'ourNumber': ourNumber,
        'financialTitlePortionCode': financialTitlePortionCode,
      };

  FinancialTitleControlDocumentEntity toEntity() =>
      FinancialTitleControlDocumentEntity(
        code: code,
        controlCode: controlCode,
        value: value,
        ourNumber: ourNumber,
        financialTitlePortionCode: financialTitlePortionCode,
      );
}

import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleRetroactivePositionModel
    extends FinancialTitleRetroactivePositionEntity {
  const FinancialTitleRetroactivePositionModel({
    required super.enterpriseCode,
    required super.financialTitleType,
    required super.grossValue,
    required super.openValue,
  });

  factory FinancialTitleRetroactivePositionModel.fromJson(Map json) =>
      FinancialTitleRetroactivePositionModel(
        enterpriseCode: json['enterpriseCode'] as int?,
        financialTitleType: FinancialTitleType.fromValue(
          json['financialTitleType'] as int?,
        ),
        grossValue: json['grossValue'] as num?,
        openValue: json['openValue'] as num?,
      );

  factory FinancialTitleRetroactivePositionModel.fromEntity(
    FinancialTitleRetroactivePositionEntity entity,
  ) =>
      FinancialTitleRetroactivePositionModel(
        enterpriseCode: entity.enterpriseCode,
        financialTitleType: entity.financialTitleType,
        grossValue: entity.grossValue,
        openValue: entity.openValue,
      );

  Map<String, dynamic> toJson() => {
        'enterpriseCode': enterpriseCode,
        'financialTitleType': financialTitleType?.value,
        'grossValue': grossValue,
        'openValue': openValue,
      };

  FinancialTitleRetroactivePositionEntity toEntity() =>
      FinancialTitleRetroactivePositionEntity(
        enterpriseCode: enterpriseCode,
        financialTitleType: financialTitleType,
        grossValue: grossValue,
        openValue: openValue,
      );
}

import '../../../../domain/entities/entities.dart';

class FinancialTitlePeriodModel extends FinancialTitlePeriodParams {
  const FinancialTitlePeriodModel({
    required super.startDate,
    required super.endDate,
  });

  factory FinancialTitlePeriodModel.fromJson(Map json) =>
      FinancialTitlePeriodModel(
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
      );

  factory FinancialTitlePeriodModel.fromEntity(
    FinancialTitlePeriodParams entity,
  ) =>
      FinancialTitlePeriodModel(
        startDate: entity.startDate,
        endDate: entity.endDate,
      );

  Map<String, dynamic> toJson() => {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  FinancialTitlePeriodParams toEntity() => FinancialTitlePeriodParams(
        startDate: startDate,
        endDate: endDate,
      );
}

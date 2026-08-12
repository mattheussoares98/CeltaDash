import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleEnterpriseModel extends FinancialTitleEnterpriseEntity {
  const FinancialTitleEnterpriseModel({
    required super.code,
    required super.name,
    required super.fantasyName,
  });

  factory FinancialTitleEnterpriseModel.fromJson(Map json) =>
      FinancialTitleEnterpriseModel(
        code: json['code'] as int?,
        name: json['name'] as String?,
        fantasyName: json['fantasyName'] as String?,
      );

  factory FinancialTitleEnterpriseModel.fromEntity(
          FinancialTitleEnterpriseEntity entity) =>
      FinancialTitleEnterpriseModel(
        code: entity.code,
        name: entity.name,
        fantasyName: entity.fantasyName,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'fantasyName': fantasyName,
      };

  FinancialTitleEnterpriseEntity toEntity() => FinancialTitleEnterpriseEntity(
        code: code,
        name: name,
        fantasyName: fantasyName,
      );
}

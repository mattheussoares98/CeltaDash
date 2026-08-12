import 'package:celta_dash/domain/entities/entities.dart';

class FinancialTitleUnitGroupModel extends FinancialTitleUnitGroupEntity {
  const FinancialTitleUnitGroupModel({
    required super.code,
    required super.name,
  });

  factory FinancialTitleUnitGroupModel.fromJson(Map json) =>
      FinancialTitleUnitGroupModel(
        code: json['code'] as int?,
        name: json['name'] as String?,
      );

  factory FinancialTitleUnitGroupModel.fromEntity(
          FinancialTitleUnitGroupEntity entity) =>
      FinancialTitleUnitGroupModel(
        code: entity.code,
        name: entity.name,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
      };

  FinancialTitleUnitGroupEntity toEntity() => FinancialTitleUnitGroupEntity(
        code: code,
        name: name,
      );
}

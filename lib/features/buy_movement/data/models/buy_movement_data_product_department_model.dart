import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';

class BuyMovementDataProductDepartmentModel
    extends BuyMovementDataProductDepartmentEntity {
  const BuyMovementDataProductDepartmentModel({
    required super.code,
    required super.name,
  });

  factory BuyMovementDataProductDepartmentModel.fromJson(Map json) =>
      BuyMovementDataProductDepartmentModel(
        code: ((json['Code'] ?? json['code']) as num?)?.toInt() ?? 0,
        name: (json['Name'] ?? json['name']) ?? '',
      );

  factory BuyMovementDataProductDepartmentModel.fromEntity(
    BuyMovementDataProductDepartmentEntity entity,
  ) => BuyMovementDataProductDepartmentModel(
    code: entity.code,
    name: entity.name,
  );

  BuyMovementDataProductDepartmentEntity toEntity() =>
      BuyMovementDataProductDepartmentEntity(code: code, name: name);

  Map toJson() => {'Code': code, 'Name': name};
}

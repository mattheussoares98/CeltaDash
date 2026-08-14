import 'package:celta_dash/features/home/domain/entities/entities.dart';

class BSFEnterpriseModel {
  const BSFEnterpriseModel({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
  });

  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  factory BSFEnterpriseModel.fromJson(Map json) => BSFEnterpriseModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    personalizedCode: json['personalizedCode'] as String?,
    cnpj: json['cnpj'] as String?,
  );

  factory BSFEnterpriseModel.fromEntity(HomeEnterpriseEntity entity) =>
      BSFEnterpriseModel(
        id: entity.id,
        name: entity.name,
        personalizedCode: entity.personalizedCode,
        cnpj: entity.cnpj,
      );

  Map toJson() => {
    'id': id,
    'name': name,
    'personalizedCode': personalizedCode,
    'cnpj': cnpj,
  };

  HomeEnterpriseEntity toEntity() => HomeEnterpriseEntity(
    id: id,
    name: name,
    personalizedCode: personalizedCode,
    cnpj: cnpj,
    enabled: false,
  );
}

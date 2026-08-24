import 'package:celta_dash/core/domain/domain.dart';

class WebEnterpriseCandidateModel {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const WebEnterpriseCandidateModel({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
  });

  factory WebEnterpriseCandidateModel.fromJson(Map json) =>
      WebEnterpriseCandidateModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        personalizedCode: json['personalizedCode'] as String?,
        cnpj: json['cnpj'] as String?,
      );

  factory WebEnterpriseCandidateModel.fromEntity(
    FirebaseSubEnterpriseEntity entity,
  ) => WebEnterpriseCandidateModel(
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

  FirebaseSubEnterpriseEntity toEntity() => FirebaseSubEnterpriseEntity(
    id: id,
    name: name,
    personalizedCode: personalizedCode,
    cnpj: cnpj,
    enabled: false,
  );
}

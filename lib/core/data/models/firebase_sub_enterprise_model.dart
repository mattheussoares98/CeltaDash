// lib/core/data/models/firebase_sub_enterprise_model.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:equatable/equatable.dart';

class FirebaseSubEnterpriseModel extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;
  final bool? enabled;

  const FirebaseSubEnterpriseModel({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
    required this.enabled,
  });

  @override
  List<Object?> get props => [id, name, personalizedCode, cnpj, enabled];

  factory FirebaseSubEnterpriseModel.fromJson(Map json) =>
      FirebaseSubEnterpriseModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        personalizedCode: json['personalizedCode'] as String?,
        cnpj: json['cnpj'] as String?,
        enabled: json['enabled'] as bool?,
      );

  factory FirebaseSubEnterpriseModel.fromEntity(
    FirebaseSubEnterpriseEntity entity,
  ) =>
      FirebaseSubEnterpriseModel(
        id: entity.id,
        name: entity.name,
        personalizedCode: entity.personalizedCode,
        cnpj: entity.cnpj,
        enabled: entity.enabled,
      );

  Map toJson() => {
        'id': id,
        'name': name,
        'personalizedCode': personalizedCode,
        'cnpj': cnpj,
        'enabled': enabled,
      };

  FirebaseSubEnterpriseEntity toEntity() => FirebaseSubEnterpriseEntity(
        id: id,
        name: name,
        personalizedCode: personalizedCode,
        cnpj: cnpj,
        enabled: enabled,
      );
}

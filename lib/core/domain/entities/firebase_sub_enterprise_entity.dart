// lib/core/domain/entities/firebase_sub_enterprise_entity.dart
import 'package:equatable/equatable.dart';

class FirebaseSubEnterpriseEntity extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;
  final bool? enabled;

  const FirebaseSubEnterpriseEntity({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
    required this.enabled,
  });

  FirebaseSubEnterpriseEntity copyWith({
    int? id,
    String? name,
    String? personalizedCode,
    String? cnpj,
    bool? enabled,
  }) => FirebaseSubEnterpriseEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    personalizedCode: personalizedCode ?? this.personalizedCode,
    cnpj: cnpj ?? this.cnpj,
    enabled: enabled ?? this.enabled,
  );

  @override
  List<Object?> get props => [id, name, personalizedCode, cnpj, enabled];
}

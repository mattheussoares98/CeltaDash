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

  @override
  List<Object?> get props => [
        id,
        name,
        personalizedCode,
        cnpj,
        enabled,
      ];
}

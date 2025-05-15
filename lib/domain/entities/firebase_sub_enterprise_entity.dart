import 'package:equatable/equatable.dart';

class FirebaseSubEnterpriseEntity extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const FirebaseSubEnterpriseEntity({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        personalizedCode,
        cnpj,
      ];
}

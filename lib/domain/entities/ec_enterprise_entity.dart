import 'package:equatable/equatable.dart';

class EcEnterpriseEntity extends Equatable {
  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const EcEnterpriseEntity({
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

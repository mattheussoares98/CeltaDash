import 'package:equatable/equatable.dart';

class HomeEnterpriseEntity extends Equatable {
  const HomeEnterpriseEntity({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
    required this.enabled,
  });

  final int? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;
  final bool enabled;

  HomeEnterpriseEntity copyWith({bool? enabled}) => HomeEnterpriseEntity(
    id: id,
    name: name,
    personalizedCode: personalizedCode,
    cnpj: cnpj,
    enabled: enabled ?? this.enabled,
  );

  @override
  List<Object?> get props => [id, name, personalizedCode, cnpj, enabled];
}
